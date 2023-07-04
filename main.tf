# code idea from https://itnext.io/lets-encrypt-certs-with-terraform-f870def3ce6d
data "aws_route53_zone" "base_domain" {
  name = var.dns_zonename
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.certificate_email
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.registration.account_key_pem
  common_name     = "${var.dns_hostname}.${var.dns_zonename}"

  recursive_nameservers        = ["1.1.1.1:53"]
  disable_complete_propagation = true

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = data.aws_route53_zone.base_domain.zone_id
    }
  }

  depends_on = [acme_registration.registration]
}


resource "local_file" "issuer_pem" {
  content  = acme_certificate.certificate.issuer_pem
  filename = "${path.module}/certificate_files/issuer.pem"
}

resource "local_file" "certificate_pem" {
  content  = acme_certificate.certificate.certificate_pem
  filename = "${path.module}/certificate_files/certificate_pem.pem"
}

resource "local_file" "full_chain" {
  content  = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
  filename = "${path.module}/certificate_files/full_chain.pem"
}

resource "local_sensitive_file" "private_key_pem" {
  content  = acme_certificate.certificate.private_key_pem
  filename = "${path.module}/certificate_files/private_key.pem"
}

resource "local_file" "private_key_pem2" {
  content_base64 = acme_certificate.certificate.certificate_p12
  filename = "${path.module}/certificate_files/certificate_p12.pfx"
}
