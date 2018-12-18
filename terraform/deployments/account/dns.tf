resource "aws_route53_zone" "root" {
  name = "frontend-tools.service.gov.uk"
}

output "root_domain_nameservers" {
	value = "${aws_route53_zone.root.name_servers}"
}
