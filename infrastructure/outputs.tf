output "lambda_function_name1" {
  value = aws_lambda_function.recommendation_books.function_name
}
output "lambda_function_name2" {
  value = aws_lambda_function.recommendation_movies.function_name
}
output "lambda_function_name3" {
  value = aws_lambda_function.preprocess_lambda.function_name
}
output "lambda_function_name4" {
  value = aws_lambda_function.ingesterbook_lambda.function_name
}
output "lambda_function_name5" {
  value = aws_lambda_function.ingestermovie_lambda.function_name
}

output "dynamodb_table2_name" {
  value = aws_dynamodb_table.movies.name
}
output "dynamodb_table1_name" {
  value = aws_dynamodb_table.books.name
}