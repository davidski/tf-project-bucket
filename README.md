`tf-project-bucket`

Creates:

-  a project-specific bucket with server-side encryption and logging to 
the central auditlogs target

- EC2 instance profile and associated IAM roles & policies for full 
read-write access to the new bucket

Expected input:

- project - Identifies the project, used to name the bucket.
- audit_bucket - Name of the pre-existing bucket in which to deposit S3 access logs.