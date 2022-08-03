# # AUTO-TAGGING

# # CLOUDTRAIL
# # ---------------------------------------------------------------

# resource "aws_cloudtrail" "tagging_mgmt_event" {
#   name                          = "cltrail-event"
#   s3_bucket_name                = aws_s3_bucket.s3_cloudtrail_log.id
#   s3_key_prefix                 = "prefix"
#   is_multi_region_trail         = false
#   enable_log_file_validation    = false
#   include_global_service_events = true

#   event_selector {
#     read_write_type           = "All"
#     include_management_events = true
#   }

#   tags = {
#     "Name" = "cloudtrail-log-for-tagging"
#   }
# }


# # S3 FOR CLOUDTRAIL LOG STORAGE
# # ---------------------------------------------------------------

# resource "aws_s3_bucket" "s3_cloudtrail_log" {
#   bucket        = "aws-s3-ctevent-logs"
#   force_destroy = true

#   tags = {
#     "Name" = "s3 cloudtrail log storage"
#   }
# }

# resource "aws_s3_bucket_acl" "s3_log_bucket_acl" {
#   bucket = aws_s3_bucket.s3_cloudtrail_log.id
#   acl    = "private"
# }

# resource "aws_s3_bucket_lifecycle_configuration" "s3_log_bucket_lfcy_conf" {
#   bucket = aws_s3_bucket.s3_cloudtrail_log.id

#   rule {
#     id     = "AWSLogs"
#     status = "Enabled" // Apply to all objects in the bucket

#     filter {
#       prefix = "AWSLogs/"
#     }

#     transition {
#       days          = 0
#       storage_class = "ONEZONE_IA"
#     }

#     expiration {
#       days = 1
#     }

#     noncurrent_version_expiration {
#       noncurrent_days = 1
#     }

#     abort_incomplete_multipart_upload {
#       days_after_initiation = 1
#     }
#   }
# }

# resource "aws_s3_bucket_policy" "s3_bucket_pol_ctlog" {
#   bucket = aws_s3_bucket.s3_cloudtrail_log.id
#   policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": "s3:GetBucketAcl",
#             "Resource": "arn:aws:s3:::aws-s3-ctevent-logs",
#             "Condition": {
#                 "StringEquals": {
#                     "aws:SourceArn": "arn:aws:cloudtrail:ap-southeast-3:455155204710:trail/aws-s3-ctevent-logs"
#                 }
#             }
#         },
#         {
#             "Sid": "VisualEditor1",
#             "Effect": "Allow",
#             "Action": "s3:PutObject",
#             "Resource": "arn:aws:s3:::aws-s3-ctevent-logs/AWSLogs/455155204710/*",
#             "Condition": {
#                 "StringEquals": {
#                     "aws:SourceArn": "arn:aws:cloudtrail:ap-southeast-3:455155204710:trail/aws-s3-ctevent-logs",
#                     "s3:x-amz-acl": "bucket-owner-full-control"
#                 }
#             }
#         }
#     ]
# } 
#   POLICY
# }

# # data "aws_iam_policy_document" "s3_allow_all" {
# #   statement {
# #     actions = [
# #       "s3:PutObject",
# #       "s3:GetObject",
# #       "s3:ListBucket",
# #       "s3:GetBucketAcl"
# #     ]

# #     resources = [
# #       aws_s3_bucket.s3_cloudtrail_log.arn,
# #       "${aws_s3_bucket.s3_cloudtrail_log.arn}/*",
# #     ]
# #   }
# # }

# # # resource "aws_iam_policy_attachment" "test-attach" {
# # #   name = "test"
# # # }
