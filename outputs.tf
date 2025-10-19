output "load_balancer_url" {
  description = "URL of the Application Load Balancer"
  value       = "http://${aws_lb.app.dns_name}"
}

output "load_balancer_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}
