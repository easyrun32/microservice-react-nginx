output "Application-loadbalancer" {
  value       = aws_lb.alb.dns_name
  description = "Alb DNS name"
}

# output "service-ec2-user"{
#   value = 
# }

resource "local_file" "env" {
  content  = "ALB_DNS=http://${aws_lb.alb.dns_name}"
  filename = "../.env"
}
