#resource "aws_s3_bucket" "automation-s3" {
#  bucket = "ece592-automation-brando"
#  acl    = "private"
#  tags = {
#    Name = "ece592-automation-brando"
#  }

# Keep old versions of the state file.
#  versioning {
#    enabled = true
#  }

# Transition old versions to cheaper storage after 30 days.
#  lifecycle_rule {
#    enabled = true
#    tags    = {}
#    noncurrent_version_transition {
#      days          = 30
#      storage_class = "STANDARD_IA"
#    }
#  }

# Encryption at rest using default AWS keys!
#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        sse_algorithm = "AES256"
#      }
#    }
#  }
#}

# Week 8 s3 bucket 
data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "foobar" {
  name                          = "tf-trail-foobar"
  s3_bucket_name                = aws_s3_bucket.week8-s3.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  is_multi_region_trail         = true
}

resource "aws_s3_bucket" "week8-s3" {
  bucket        = "ece592-cloudtrail-brando"
  force_destroy = true
  tags = {
    Name = "ece592-cloudtrail-brando"
  }


  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::ece592-cloudtrail-brando"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::ece592-cloudtrail-brando/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
