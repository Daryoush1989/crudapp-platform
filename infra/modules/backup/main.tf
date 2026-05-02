data "aws_iam_policy_document" "backup_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_backup_vault" "this" {
  name = "${var.name_prefix}-${var.environment}-backup-vault"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-backup-vault"
    Tier = "resilience"
  })
}

resource "aws_iam_role" "backup" {
  name               = "${var.name_prefix}-${var.environment}-backup-role"
  assume_role_policy = data.aws_iam_policy_document.backup_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-backup-role"
    Tier = "resilience"
  })
}

resource "aws_iam_role_policy_attachment" "backup" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_backup_plan" "this" {
  name = "${var.name_prefix}-${var.environment}-backup-plan"

  rule {
    rule_name         = "daily-rds-backup"
    target_vault_name = aws_backup_vault.this.name
    schedule          = var.backup_schedule
    start_window      = var.start_window_minutes
    completion_window = var.completion_window_minutes

    lifecycle {
      delete_after = var.delete_after_days
    }

    recovery_point_tags = merge(var.tags, {
      BackupPlan = "${var.name_prefix}-${var.environment}-backup-plan"
    })
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-backup-plan"
    Tier = "resilience"
  })
}

resource "aws_backup_selection" "this" {
  iam_role_arn = aws_iam_role.backup.arn
  name         = "${var.name_prefix}-${var.environment}-bk-sel"
  plan_id      = aws_backup_plan.this.id
  resources    = var.backup_resource_arns

  depends_on = [
    aws_iam_role_policy_attachment.backup
  ]
}