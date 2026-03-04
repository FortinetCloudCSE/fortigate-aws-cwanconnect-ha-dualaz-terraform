output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet1_id" {
  value = aws_subnet.public_subnet1.id
}

output "public_subnet2_id" {
  value = aws_subnet.public_subnet2.id
}

output "private_subnet1_id" {
  value = aws_subnet.private_subnet1.id
}

output "private_subnet2_id" {
  value = aws_subnet.private_subnet2.id
}

output "hamgmt_subnet1_id" {
  value = aws_subnet.hamgmt_subnet1.id
}

output "hamgmt_subnet2_id" {
  value = aws_subnet.hamgmt_subnet2.id
}

output "cwan_peer1_core_network_address1" {
  value = aws_networkmanager_connect_peer.cwan_connect_peer1.configuration[0].bgp_configurations[0].core_network_address
}

output "cwan_peer1_core_network_address2" {
  value = aws_networkmanager_connect_peer.cwan_connect_peer1.configuration[0].bgp_configurations[1].core_network_address
}

output "cwan_peer2_core_network_address1" {
  value = aws_networkmanager_connect_peer.cwan_connect_peer2.configuration[0].bgp_configurations[0].core_network_address
}

output "cwan_peer2_core_network_address2" {
  value = aws_networkmanager_connect_peer.cwan_connect_peer2.configuration[0].bgp_configurations[1].core_network_address
}