
# DynamoDB Table (your interactions / users / items)
resource "aws_dynamodb_table" "books" {
name         = "Books"
billing_mode = "PAY_PER_REQUEST"
hash_key     = "bookId"       # Adjust to your actual keys
# range_key    = "itemId"       # Example - change as per your schema

attribute {
name = "bookId"
type = "S"
}

# attribute {
# name = "itemId"
# type = "S"
# }
# Add more attributes/indexes later as needed
}

resource "aws_dynamodb_table" "movies" {
  name         = "Movies"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "movieId"       # Adjust to your actual keys
  # range_key    = "itemId"       # Example - change as per your schema
  attribute {
    name = "movieId"
    type = "S"
  }

  # attribute {
  #   name = "itemId"
  #   type = "S"
  # }

  # Add more attributes/indexes later as needed
}

# IAM Role for Lambda (basic - add more policies later)
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# DynamoDB access policy (attach to role)
resource "aws_iam_role_policy" "dynamodb_access" {
  name = "dynamodb-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:Query", "dynamodb:Scan", "dynamodb:UpdateItem"]
      Resource = aws_dynamodb_table.books.arn
    }]
  })
}
resource "aws_iam_role_policy" "dynamodb_access2" {
  name = "dynamodb-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:Query", "dynamodb:Scan", "dynamodb:UpdateItem"]
      Resource = aws_dynamodb_table.movies.arn
    }]
  })
}

resource "aws_lambda_function" "recommendation_books" {

  function_name    = "BookRecommender"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"  # Your file.function name
  runtime          = "python3.13"                       # Or python3.11 / 3.10
  timeout          = 30
  memory_size      = 256

  # Dummy to pass validation (small empty zip is fine)
  filename = "dummy.zip"   # we'll create this tiny file next

  # IMPORTANT: Ignore code changes so Terraform doesn't try to replace/re-upload
  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,     # if you have this
      s3_bucket,
      s3_key,
      image_uri,
    ]
  }


  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.books.name
      # Add more env vars like REGION if needed
    }
  }
}
resource "aws_lambda_function" "recommendation_movies" {

  function_name    = "MovieRecommender"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"  # Your file.function name
  runtime          = "python3.13"                       # Or python3.11 / 3.10
  timeout          = 3
  memory_size      = 256

  # Dummy to pass validation (small empty zip is fine)
  filename = "dummy.zip"   # we'll create this tiny file next

  # IMPORTANT: Ignore code changes so Terraform doesn't try to replace/re-upload
  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,     # if you have this
      s3_bucket,
      s3_key,
      image_uri,
    ]
  }

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.movies.name
      # Add more env vars like REGION if needed
    }
  }
}
resource "aws_lambda_function" "preprocess_lambda" {

  function_name    = "preProcess"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"  # Your file.function name
  runtime          = "python3.13"                       # Or python3.11 / 3.10
  timeout          = 30
  memory_size      = 256

  # Dummy to pass validation (small empty zip is fine)
  filename = "dummy.zip"   # we'll create this tiny file next

  # IMPORTANT: Ignore code changes so Terraform doesn't try to replace/re-upload
  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,     # if you have this
      s3_bucket,
      s3_key,
      image_uri,
    ]
  }

  environment {
    variables = {
      TABLE_NAME1 = aws_dynamodb_table.books.name
      TABLE_NAME2 = aws_dynamodb_table.movies.name
      # Add more env vars like REGION if needed
    }
  }
}
resource "aws_lambda_function" "ingesterbook_lambda" {

  function_name    = "Bookingester"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"  # Your file.function name
  runtime          = "python3.13"                       # Or python3.11 / 3.10
  timeout          = 30
  memory_size      = 256

  # Dummy to pass validation (small empty zip is fine)
  filename = "dummy.zip"   # we'll create this tiny file next

  # IMPORTANT: Ignore code changes so Terraform doesn't try to replace/re-upload
  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,     # if you have this
      s3_bucket,
      s3_key,
      image_uri,
    ]
  }

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.books.name
      # Add more env vars like REGION if needed
    }
  }
}
resource "aws_lambda_function" "ingestermovie_lambda" {

  function_name    = "Movieingester"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"  # Your file.function name
  runtime          = "python3.13"                       # Or python3.11 / 3.10
  timeout          = 30
  memory_size      = 256

  # Dummy to pass validation (small empty zip is fine)
  filename = "dummy.zip"   # we'll create this tiny file next

  # IMPORTANT: Ignore code changes so Terraform doesn't try to replace/re-upload
  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,     # if you have this
      s3_bucket,
      s3_key,
      image_uri,
    ]
  }

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.movies.name
      # Add more env vars like REGION if needed
    }
  }
}
