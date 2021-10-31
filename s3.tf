# Week 8 s3 bucket 
data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "automation-cloudtrail-v2" {
  name                          = "automation-cloudtrail-v2"
  s3_bucket_name                = aws_s3_bucket.ece592-athena-cache-v2.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  is_multi_region_trail         = true
}

resource "aws_s3_bucket" "ece592-athena-cache-v2" {
  bucket        = "ece592-athena-cache-v2"
  force_destroy = true
  tags = {
    Name = "ece592-athena-cache-v2"
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
            "Resource": "arn:aws:s3:::ece592-athena-cache-v2"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::ece592-athena-cache-v2/*",
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
