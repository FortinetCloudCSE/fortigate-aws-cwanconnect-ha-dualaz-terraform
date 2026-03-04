output "fgt_login_info" {
  value = <<-FGTLOGIN
# fgt username: admin
# fgt initial password: ${module.fgcp.fgt1_id}
# cluster login url: https://${module.fgcp.cluster_eip_public_ip}
# fgt1 login url: https://${module.fgcp.fgt1_hamgmt_ip}
# fgt2 login url: https://${module.fgcp.fgt2_hamgmt_ip}
FGTLOGIN
}

output "cwan_new" {
  value = var.cwan_creation == "yes" ? (
    <<-CWANNEW
# cwan id: ${module.cloud-wan[0].cwan_id}
# cwan arn: ${module.cloud-wan[0].cwan_arn}
# cwan segment key: segment
# cwan segment values = inspection, production, development
CWANNEW
  ) : ""
}

output "cwan_existing" {
  value = var.cwan_creation == "no" ? (
    <<-CWANEXISTING
# cwan id: var.cwan_existing_id
# cwan arn: var.cwan_arn
# cwan segment key: var.cwan_existing_segment_key
# cwan segment value = var.cwan_existing_segment_value
CWANEXISTING
  ) : ""
}