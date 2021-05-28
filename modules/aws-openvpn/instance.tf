locals {
  images = {
    us-east-1      = "ami-037ff6453f0855c46"
    eu-central-1   = "ami-0764964fdfe99bc31"
    ap-northeast-1 = "ami-04f47c2ec43830d77"
  }
}


resource "aws_instance" "openvpn" {
  ami                         = local.images[var.region]
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  source_dest_check           = false
  key_name                    = "ankittripathijnjKeypair"
  vpc_security_group_ids      = [aws_security_group.instance.id]
  #user_data                   = data.template_file.init.template
  user_data = <<-EOF
              #!/bin/bash
              admin_user=${var.openvpn_username}
              admin_pw=${var.openvpn_password}
              sudo touch /tmp/output.txt
              EC2_INSTANCE_ID="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`"
              EOF

  tags = {
    Name = "openvpn"
  }
}



/*data "template_file" "init" {
  template = "${file("${path.module}/template/cloud-config/openvpn.tpl")}"

  vars = {
 
      admin_user = var.openvpn_username
      admin_pw = var.openvpn_password
   }
}*/



