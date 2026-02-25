variable "aws_region" {
  type        = string                     # The type of the variable, in this case a string
  default     = "us-east-1"                 # Default value for the variable
  description = "AWS Region" # Description of what this variable represents
}

variable "project_name" {
  description = "Project prefix"
  type = string
  default = "rec-service"
}

variable "dynamodb_table1_name" {
  type = string
  default = "Books"
}

variable "dynamodb_table2_name" {
  type = string
  default = "Movies"
}