output "mount-target-dns" {
  description = "Address of the mount target provisioned."
  value       = "${aws_efs_mount_target.main_subnet1.dns_name}"
}
