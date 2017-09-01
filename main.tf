terraform {
  backend "s3" {
    bucket = "hackerati-terraform-backends"
    key    = "skills-framework-test"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "skills-framework-test" {
  name = "skills-framework-test"
  path = "/service-role/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "skills-framework-test" {
  filename         = "dist/skills-framework-test.zip"
  function_name    = "skills-framework-test"
  role             = "${aws_iam_role.skills-framework-test.arn}"
  handler          = "lambda.handler"
  source_code_hash = "${base64sha256(file("${path.module}/dist/skills-framework-test.zip"))}"
  runtime          = "nodejs6.10"
}
