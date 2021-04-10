module "api-gateway" {
  source        = "./modules/terraform-aws-api-gateway-master"
  # version       = "0.14.1"
  types = ["REGIONAL"]
  repository  = ""
  name        = "api-gateway"
  environment = "test"
  label_order = ["name", "environment"]
  enabled     = true
  # Api Gateway Resource
  path_parts = ["authors", "course"]
  # Api Gateway Method
  method_enabled = true
  http_methods   = ["GET", "GET"]
  # Api Gateway Integration
  integration_types        = ["AWS", "AWS"]
  integration_http_methods = ["POST", "POST"]
  uri                      = [module.lambda.get_all_authors_invoke_arn, module.lambda.get_all_courses_invoke_arn]
  integration_request_parameters = [{
    "integration.request.header.X-Authorization" = "'static'"
  }, {
    "integration.request.header.X-Authorization" = "'static'"
  }]
  request_templates = [{
    "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
  }, {
       "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
  }]
  # Api Gateway Method Response
  status_codes        = [200, 200]
  response_models     = [{ "application/json" = "Empty" }, { "application/json" = "Empty"  }]
  response_parameters = [{ "method.response.header.X-Some-Header" = true }, { "method.response.header.X-Some-Header" = true }]
  # Api Gateway Integration Response
  integration_response_parameters = [{ "method.response.header.X-Some-Header" = "integration.response.header.X-Some-Other-Header" }, { "method.response.header.X-Some-Header" = "integration.response.header.X-Some-Other-Header" }]
  /*response_templates = [{
    "application/xml" = <<EOF
  #set($inputRoot = $input.path('$'))
  <?xml version="1.0" encoding="UTF-8"?>
  <message>
      $inputRoot.body
  </message>
  EOF
  }, {}]*/
  # Api Gateway Deployment
  deployment_enabled = true
  stage_name         = "deploy"
  # Api Gateway Stage
  stage_enabled = true
  stage_names   = ["qa", "dev"]
  # Api Gateway Client Certificate
  cert_enabled     = true
  cert_description = "clouddrove"
  # Api Gateway Authorizer
  /*authorizer_count                = 2
  authorizer_names                = ["test", "test1"]
  authorizer_uri                  = ["arn:aws:apigateway:eu-central-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-central-1:657694663228:function:test/invocations", "arn:aws:apigateway:eu-central-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-central-1:657694663228:function:test/invocations"]
  authorizer_credentials          = ["arn:aws:iam::657694663228:role/lambda-role", "arn:aws:iam::657694663228:role/lambda-role"]
  identity_sources                = ["method.request.header.Authorization", "method.request.header.Authorization"]
  identity_validation_expressions = ["sfdgfhghrfdsdas", ""]
  authorizer_types                = ["TOKEN", "REQUEST"]*/
  # Api Gateway Gateway Response
  gateway_response_count = 2
  response_types         = ["UNAUTHORIZED", "UNAUTHORIZED"]
  gateway_status_codes   = ["401", "401"]
  # Api Gateway Model
  model_count   = 2
  model_names   = ["test", "test1"]
  content_types = ["application/json", "application/json"]
  # Api Gateway Api Key
  key_count = 2
  key_names = ["test", "test1"]
  content_handlings = ["CONVERT_TO_TEXT", "CONVERT_TO_TEXT"]
}