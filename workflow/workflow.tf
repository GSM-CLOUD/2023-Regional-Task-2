resource "aws_glue_workflow" "glue_workflow" {
  name = "${var.prefix}-glue-workflow"
  tags = {
    Name = "${var.prefix}-glue-workflow"
  }
}

resource "aws_glue_trigger" "crawler_trigger" {
  name          = "${var.prefix}-crawler-trigger"
  type          = "ON_DEMAND"
  workflow_name = aws_glue_workflow.glue_workflow.name

  actions {
    crawler_name = var.crawler_name
  }
}


resource "aws_glue_trigger" "crawlering_success" {
  name          = "crawlering_success"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name

  predicate {
    logical = "AND"
    conditions {
      crawler_name = var.crawler_name
      crawl_state = "SUCCEEDED"
    }
  }

  actions {
    job_name = "wsi-glue-job"
  }
}
