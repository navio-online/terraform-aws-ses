resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "bucket-owner-full-control"

  tags = {
    Name        = var.bucket_name
    Environment = "infra"
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.bucket.json
}

data "aws_iam_policy_document" "bucket" {
  statement {
    sid = "AllowWriteToSesAmazonCom"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    principals {
      type = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    resources = [
      "${aws_s3_bucket.this.arn}",
      "${aws_s3_bucket.this.arn}/*"
    ]
  }

  statement {
    sid = "AllowReadOnlyOperationsToReadOnlyArns"

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectAcl",
    ]

    principals {
      type = "AWS"
      identifiers = distinct(concat(
        var.readonly_arns,
        var.readwrite_arns,
        var.admin_arns,
      ))
    }

    resources = [
      "${aws_s3_bucket.this.arn}",
      "${aws_s3_bucket.this.arn}/*"
    ]
  }

  statement {
    sid = "AllowReadWriteOperationsToReadWriteArns"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    principals {
      type = "AWS"
      identifiers = distinct(concat(
        var.readwrite_arns,
        var.admin_arns,
      ))
    }

    resources = [
      "${aws_s3_bucket.this.arn}",
      "${aws_s3_bucket.this.arn}/*"
    ]
  }

  statement {
    sid = "AllowAllOperationsToAdminArns"

    actions = [
      "s3:*"
    ]

    principals {
      type = "AWS"
      identifiers = var.admin_arns
    }

    resources = [
      "${aws_s3_bucket.this.arn}",
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  depends_on = [ aws_s3_bucket_policy.bucket ]

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
