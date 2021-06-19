output "lambda_function_name" {
  value = aws_lambda_function.api.function_name
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.api.invoke_arn
}

output "lambda_arn" {
  value = aws_lambda_function.api.arn
}
