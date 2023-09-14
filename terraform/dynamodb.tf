module "dynamodb_library_metadata" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "3.3.0"

  name                        = "dj-library-metadata"
  hash_key                    = "ID"
  range_key                   = "S3ObjectKey"
  table_class                 = "STANDARD"
  deletion_protection_enabled = false

  attributes = [
    {
      name = "ID"
      type = "S"
    },
    {
      name = "S3ObjectKey"
      type = "S"
    }
  ]
}