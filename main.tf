module "vpc" {
  source = "./vpc"
  prefix = var.prefix
  region = data.aws_region.current_region.name
}

module "ec2" {
  source             = "./ec2"
  prefix             = var.prefix
  ami_id             = data.aws_ami.amzn2-ami.id
  instance_type      = "t3.small"
  public_subnet_a_id = module.vpc.public_subnet_a_id
  vpc_id             = module.vpc.vpc_id

  depends_on = [module.vpc]
}

module "s3" {
  source = "./s3"
  prefix = var.prefix

  depends_on = [module.ec2]
}

module "api_gateway" {
  source = "./apigateway"
  prefix = var.prefix
  region = data.aws_region.current_region.name

  depends_on = [module.s3]
}

module "stream" {
  source = "./stream"
  prefix = var.prefix

  depends_on = [module.api_gateway]
}

module "fire_hose" {
  source             = "./firehose"
  prefix             = var.prefix
  kinesis_stream_arn = module.stream.kinesis_stream_arn
  bucket_arn         = module.s3.bucket_arn

  depends_on = [module.stream]
}

module "database" {
  source = "./database"
  prefix = var.prefix

  depends_on = [module.fire_hose]
}

module "crawler" {
  source        = "./crawler"
  prefix        = var.prefix
  bucket_name   = module.s3.bucket_name
  database_name = module.database.database_name

  depends_on = [module.database]

}

resource "time_sleep" "wait_after_crawler" {
    depends_on = [ module.crawler ]
  create_duration = "120s"
}

module "job" {
  source = "./job"
  prefix = var.prefix
  bucket_name = module.s3.bucket_name
  
  depends_on = [ time_sleep.wait_after_crawler ]
}

module "workflow" {
  source = "./workflow"
  prefix = var.prefix
  crawler_name = module.crawler.crawler_name
  glue_job_name = module.job.glue_job_name

  depends_on = [ module.job ]
}