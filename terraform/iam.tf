resource "aws_iam_policy" "dj_library_policy" {
  name        = "DJLibraryAccess"
  description = "Policy for DJ Library operations on S3 and DynamoDB."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket"],
        Resource = [
          module.s3_dj_library.s3_bucket_arn,
          "${module.s3_dj_library.s3_bucket_arn}/*"
        ],
        Effect = "Allow"
      },
      {
        Action   = ["dynamodb:PutItem", "dynamodb:GetItem", "dynamodb:UpdateItem", "dynamodb:DeleteItem", "dynamodb:Query", "dynamodb:Scan"],
        Resource = module.dynamodb_library_metadata.dynamodb_table_arn,
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "dj_library_lambda_role" {
  name = "DJLibraryLambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dj_library_lambda_role_attach" {
  policy_arn = aws_iam_policy.dj_library_policy.arn
  role       = aws_iam_role.dj_library_lambda_role.name
}

resource "aws_iam_policy" "github_actions_policy" {
  name        = "GitHubActionsAccess"
  description = "Policy for GitHubActions operations."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["*"],
        Resource = ["*"],
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "github_actions" {
  name = "GitHubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::231423573345:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:MisterCWalker/DJLibAPI:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "github_actions_admin_access_role_attach" {
  name       = "GitHubActionsAdminAccessAttachment"
  policy_arn = aws_iam_policy.github_actions_policy.arn
  roles      = [aws_iam_role.github_actions.name]
}
