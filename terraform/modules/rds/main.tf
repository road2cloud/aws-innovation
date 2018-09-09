resource "aws_db_subnet_group" "pgsql_subnet" {
    name = "pgsql-subnet"
    description = "RDS subnet group"
    subnet_ids = ["${var.private_subnet1_id}","${var.private_subnet2_id}"]
}

resource "aws_db_parameter_group" "pgsql_parameters" {
    name = "pgsql-parameters"
    family = "postgres9.6"
    description = "PQSQL parameter group"
}

resource "aws_db_instance" "postgresql" {
  allocated_storage    = 5    # 100 GB of storage, gives us more IOPS than a lower number
  engine               = "postgres"
  engine_version       = "9.6.3"
  instance_class       = "${var.instance_type}"   # use micro if you want to use the free tier
  identifier           = "${var.database_identifier}"
  name                 = "postgres"
  username             = "root"   # username
  password             = "${var.RDS_PASSWORD}" # password
  db_subnet_group_name = "${aws_db_subnet_group.pgsql_subnet.name}"
  parameter_group_name = "${aws_db_parameter_group.pgsql_parameters.name}"
  multi_az             = "false"     # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids = ["${aws_security_group.allow-pgsql.id}"]
  storage_type         = "gp2"
  storage_encrypted    = false
  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  backup_retention_period = 30    # how long you’re going to keep your backups
  multi_az = "false"
  publicly_accessible = "false"
  # availability_zone = "${aws_subnet.main-private-1.availability_zone}"   # prefered AZ
  # skip_final_snapshot = true   # skip final snapshot when doing terraform destroy

  allow_major_version_upgrade = "false"
  auto_minor_version_upgrade = "true"
  apply_immediately = "false"
  maintenance_window = "Mon:00:00-Mon:03:00"
  skip_final_snapshot = "true"
  final_snapshot_identifier = "labarc"
  backup_retention_period = 1
  backup_window = "03:00-06:00"

  #enabled_cloudwatch_logs_exports = ["error"] #Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace."

  tags {
      Name = "pgsql-instance"
  }
}

/*resource "null_resource" "db_setup" {
  depends_on = ["aws_db_instance.postgresql", "aws_security_group.allow-pgsql"]
  provisioner "local-exec" {
    command = "echo ${aws_db_instance.postgresql.endpoint} >> packer/data/endpoint.html"
  }
}*/

resource "aws_security_group" "allow-pgsql" {
  vpc_id = "${var.vpc_id}"
  name = "allow-pgsql"
  description = "allow-pgsql"
  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      #security_groups = ["${var.public_sg}"]  # allowing access from our instance
      cidr_blocks = ["0.0.0.0/0"]  # allowing access from our instance
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      self = true
  }
  tags {
    Name = "allow-pgsql"
  }
}

#
# CloudWatch resources
#
/*resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  alarm_name          = "alarmDatabaseServerCPUUtilization-${var.database_identifier}"
  alarm_description   = "Database server CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.alarm_cpu_threshold}"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.postgresql.id}"
  }

  alarm_actions             = ["${var.alarm_actions}"]
  ok_actions                = ["${var.ok_actions}"]
  insufficient_data_actions = ["${var.insufficient_data_actions}"]
}

resource "aws_cloudwatch_metric_alarm" "database_disk_queue" {
  alarm_name          = "alarmDatabaseServerDiskQueueDepth-${var.database_identifier}"
  alarm_description   = "Database server disk queue depth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.alarm_disk_queue_threshold}"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.postgresql.id}"
  }

  alarm_actions             = ["${var.alarm_actions}"]
  ok_actions                = ["${var.ok_actions}"]
  insufficient_data_actions = ["${var.insufficient_data_actions}"]
}

resource "aws_cloudwatch_metric_alarm" "database_disk_free" {
  alarm_name          = "alarmDatabaseServerFreeStorageSpace-${var.database_identifier}"
  alarm_description   = "Database server free storage space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.alarm_free_disk_threshold}"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.postgresql.id}"
  }

  alarm_actions             = ["${var.alarm_actions}"]
  ok_actions                = ["${var.ok_actions}"]
  insufficient_data_actions = ["${var.insufficient_data_actions}"]
}

resource "aws_cloudwatch_metric_alarm" "database_memory_free" {
  alarm_name          = "alarmDatabaseServerFreeableMemory-${var.database_identifier}"
  alarm_description   = "Database server freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.alarm_free_memory_threshold}"

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.postgresql.id}"
  }

  alarm_actions             = ["${var.alarm_actions}"]
  ok_actions                = ["${var.ok_actions}"]
  insufficient_data_actions = ["${var.insufficient_data_actions}"]
}*/
