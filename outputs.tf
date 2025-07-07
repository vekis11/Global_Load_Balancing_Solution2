output "load_balancer_ip" {
  description = "The IP address of the global load balancer."
  value       = google_compute_global_forwarding_rule.default.ip_address
} 