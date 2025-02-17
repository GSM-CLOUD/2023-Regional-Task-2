import sys

from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsgluedq.transforms import EvaluateDataQuality

# JOB_NAME을 인자로 받아 초기화
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

# Glue Job 객체 초기화
job = Job(glueContext)  # GlueContext를 전달하여 Job 객체 생성
job.init(args['JOB_NAME'], args)  # JOB_NAME과 args를 전달하여 초기화

# 기본 데이터 품질 규칙 (모든 대상 노드에 적용)
DEFAULT_DATA_QUALITY_RULESET = """
    Rules = [
        ColumnCount > 0
    ]
"""

# raw 테이블 데이터를 Glue Data Catalog에서 읽어옴
raw_node = glueContext.create_dynamic_frame.from_catalog(
    database="wsi-glue-database", 
    table_name="raw", 
    transformation_ctx="raw_node"
)

# ref 테이블 데이터를 Glue Data Catalog에서 읽어옴
ref_node = glueContext.create_dynamic_frame.from_catalog(
    database="wsi-glue-database", 
    table_name="ref", 
    transformation_ctx="ref_node"
)

# Join: raw와 ref를 title_id 컬럼 기준으로 조인
join_node = Join.apply(
    frame1=raw_node, 
    frame2=ref_node, 
    keys1=["title_id"], 
    keys2=["title_id"], 
    transformation_ctx="join_node"
)

# Change Schema: 컬럼 매핑 및 스키마 변경 (원하는 컬럼만 선택)
change_schema_node = ApplyMapping.apply(
    frame=join_node,
    mappings=[
        ("uuid", "string", "uuid", "string"),
        ("device_ts", "string", "device_ts", "string"),
        ("device_id", "int", "device_id", "int"),
        ("title_id", "int", "title_id", "int"),
        ("device_type", "string", "device_type", "string"),
        ("title", "string", "title", "string")
    ],
    transformation_ctx="change_schema_node"
)

# 데이터 품질 평가 수행
EvaluateDataQuality().process_rows(
    frame=change_schema_node,
    ruleset=DEFAULT_DATA_QUALITY_RULESET,
    publishing_options={
        "dataQualityEvaluationContext": "EvaluateDataQuality_node",
        "enableDataQualityResultsPublishing": True
    },
    additional_options={
        "dataQualityResultsPublishing.strategy": "BEST_EFFORT",
        "observations.scope": "ALL"
    }
)

# Amazon S3에 결과를 저장하고 Glue Data Catalog 업데이트
s3_sink = glueContext.getSink(
    path="s3://wsi-99-ssss-etl/result/",
    connection_type="s3",
    updateBehavior="UPDATE_IN_DATABASE",
    partitionKeys=[],
    enableUpdateCatalog=True,
    transformation_ctx="s3_sink"
)
s3_sink.setCatalogInfo(
    catalogDatabase="wsi-glue-database",
    catalogTableName="result"
)
s3_sink.setFormat("glueparquet", compression="snappy")
s3_sink.writeFrame(change_schema_node)

job.commit()  # Glue job 종료
