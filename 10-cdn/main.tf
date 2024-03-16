#creating Cloudfront distribution :
resource "aws_cloudfront_distribution" "nikhildevops" {
  enabled             = true
  aliases             = ["web-${var.tags.component}.${var.zone_name}"]
  origin {
    domain_name = "web-${var.environment}.${var.zone_name}"
    origin_id   = "web-${var.environment}.${var.zone_name}"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  
  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "web-${var.environment}.${var.zone_name}"
    cache_policy_id = data.aws_cloudfront_cache_policy.cache.id
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "web-${var.environment}.${var.zone_name}"
    cache_policy_id = data.aws_cloudfront_cache_policy.cache.id
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "https-only"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "web-${var.environment}.${var.zone_name}"
    viewer_protocol_policy = "https-only"
    cache_policy_id = data.aws_cloudfront_cache_policy.no_cache.id
    
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA"]
    }
  }
  tags = merge(
    var.common_tags,
    var.tags
   )
  viewer_certificate {
    acm_certificate_arn      = var.aws_ssm_parameter.acm_certificate_arn.value
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  
  zone_name = var.zone_name

  records = [
    {
      name    = "web-cdn"   #web-cdn.nikhildevops.online
      type    = "A"
      alias   = {
        name    = aws_cloudfront_distribution.nikhildevops.domain_name
        zone_id = aws_cloudfront_distribution.nikhildevops.hosted_zone_id
      }
    }    
  ]

}