module "frontend" {
  source      = "./modules/s3/eu-central-1"
  context     = module.base_labels.context
  name        = "frontend"
  label_order = var.label_order
  # region = var.region
#   domain_name = local.domain_name
#   zone_id     = aws_route53_zone.this.zone_id
#   marketplace_cloudfront_min_ttl = var.marketplace_cloudfront_min_ttl
#   marketplace_cloudfront_default_ttl = var.marketplace_cloudfront_default_ttl
#   marketplace_cloudfront_max_ttl = var.marketplace_cloudfront_max_ttl
}

module "dynamo_db_courses" {
  source      = "./modules/dynamodb/eu-central-1"
  context     = module.base_labels.context
  name        = "courses"
}

module "dynamo_db_authors" {
  source      = "./modules/dynamodb/eu-central-1"
  context     = module.base_labels.context
  name        = "authors"
}

module "lambda" {
  source      = "./modules/lambda/eu-central-1"
  context     = module.base_labels.context
  name        = "lambda"
  
  role_get_all_authors_arn    = module.iam.role_get_all_authors_arn
  role_get_all_courses_arn    = module.iam.role_get_all_courses_arn
  role_get_course_arn         = module.iam.role_get_course_arn
  role_save_update_course_arn = module.iam.role_save_update_course_arn
  role_delete_course_arn      = module.iam.role_delete_course_arn

  dynamo_db_authors_name       = module.dynamo_db_authors.role_dynamodb_name
  dynamo_db_courses_name       = module.dynamo_db_courses.role_dynamodb_name
}

module "iam" {
  source                = "./modules/iam"
  context               = module.base_labels.context
  name                  = "iam"
  dynamo_db_authors_arn = module.dynamo_db_authors.role_dynamodb_arn
  dynamo_db_courses_arn = module.dynamo_db_courses.role_dynamodb_arn
}

resource "aws_dynamodb_table" "example" {
  name            = module.base_labels.id
  hash_key        = "id"

  billing_mode    = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }
}

module "Notified_Lambda" {
  source            = "./modules/Notified_Lambda/eu-central-1"
  context           = module.base_labels.context
  name              = "Notified_Lambda"
  alarm_emails      = var.alarm_emails
  slack_webhook_url = var.slack_webhook_url
  author_name       = var.author_name
}

module "budget" {
  source                     = "./modules/budget/eu-central-1"
  context                    = module.base_labels.context
  name                       = "budget"
  subscriber_email_addresses = var.subscriber_email_addresses
  slack_webhook_url          = var.slack_webhook_url
  author_name                = var.author_name
}



############################################################################ Pererobyty



##############################################################################




















/*
data "aws_caller_identity" "current" {}


module "cost_mgmt_notif" {
  source                =  "git::https://github.com/binbashar/terraform-aws-cost-budget.git?ref=v1.0.10"

  aws_env               = var.stage
  currency              = "USD"
  limit_amount          = "1.0"
  time_unit             = "MONTHLY"
  time_period_start     = "2019-01-01_00:00"
  aws_sns_account_id    = data.aws_caller_identity.current.account_id
  
  for_each = ["yurii.zhuravchak.itis.2019@lpnu.ua", "yurii.zhuravchak.itis.2019@lpnu.ua", "yurii.zhuravchak.itis.2019@lpnu.ua"]
  aws_sns_account_id    = cost_mgmt_notif.value
  
}
*/
