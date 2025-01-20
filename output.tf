output "db_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}

output "db_instance_id" {
  value = aws_db_instance.postgres_db.id
}
output "instance_id" {
  value = aws_autoscaling_group.asg.*.id
}