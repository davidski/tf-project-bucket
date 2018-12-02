/*
  -------------
  | S3 Bucket |
  -------------
*/
resource "aws_s3_bucket" "project_bucket" {
  bucket = "${var.project}-severski"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name       = "${var.project} bucket"
    project    = "${var.project}"
    managed_by = "Terraform"
  }

  logging {
    target_bucket = "${var.audit_bucket}"
    target_prefix = "s3logs/${var.project}-severski/"
  }
}

/*
  -------------
  | IAM Roles |
  -------------
*/

resource "aws_iam_role" "s3_accessor" {
  name_prefix = "${var.project}"
  description = "Allow access to S3 project bucket"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF

  tags {
    project    = "${var.project}"
    managed_by = "Terraform"
  }
}

resource "aws_iam_policy" "policy" {
  name_prefix = "${var.project}"
  description = "Full RW acceess to project S3 bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:GetBucketPolicy"
            ],
            "Resource": "${aws_s3_bucket.project_bucket.arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": "${aws_s3_bucket.project_bucket.arn}/*"
        }
      ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_accessor" {
  role       = "${aws_iam_role.s3_accessor.id}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name_prefix = "${var.project}"
  role        = "${aws_iam_role.s3_accessor.name}"
}

output "ec2_instance_profile_arn" {
  value = "${aws_iam_instance_profile.ec2_profile.arn}"
}

output "project_bucket_id" {
  value = "${aws_s3_bucket.project_bucket.id}"
}
