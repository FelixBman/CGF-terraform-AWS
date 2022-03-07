#Create key-pair for logging into EC2 in us-east-1
#resource "aws_key_pair" "master-key" {
#  key_name   = "ssh-key"
#  public_key = file("./ssh_pubkey")
#}


output "server_public_ip" {
  value = aws_eip.one.public_ip
}
output "instancID" {
  value = aws_instance.CloudGenFirewall.id
}
output "CCIP" {
  value = var.CC_IP
}

resource "aws_network_interface" "firewall-nic" {
  subnet_id              = aws_subnet.firewall.id
    #Setting a fixed IP DHCP IP is optional
  #private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.cgf-sg.id]
  2222222222222222222222222222222222222222222222222222222222222222 = false
}


resource "aws_eip" "one" {
  vpc               = true
  network_interface = aws_network_interface.firewall-nic.id #   associate_with_private_ip = "10.0.1.50"
  depends_on        = [aws_internet_gateway.igw]
}

resource "aws_instance" "CloudGenFirewall" {
  ami               = "ami-06ccb7d96ef307528"
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  key_name          = "ssh-key"
  tags = {
    Name = "CloudGen Firewall"
  }
  user_data = <<-EOF
            #!/bin/bash
            echo "${var.SharedKey}" | getpar -a "${var.CC_IP}" -r "${var.Range_ID}" -c "${var.Cluster_Name}" -b "${var.Box_Name}" -d /opt/phion/update/box.par
            /usr/sbin/reboot
    EOF
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.firewall-nic.id
  }
}