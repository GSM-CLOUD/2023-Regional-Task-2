resource "null_resource" "start_crawler" {
  depends_on = [ aws_glue_crawler.crawler ]

  provisioner "local-exec" {
    command = "aws glue start-crawler --name ${aws_glue_crawler.crawler.name}"
  }
}