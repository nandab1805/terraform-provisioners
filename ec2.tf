resource "aws_instance" "web" { 
  ami           = "ami-0b4f379183e5706b9"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.roboshop-all.id]
  tags = {
    Name = "provisioner"
  }

provisioner "local-exec" {
  command = "echo this will excute at the time of creation,you can trigger other system like email and sending alerts "
}

provisioner "local-exec" {
    command = "echo  ${self.private_ip} > inventory" #self = aws_instance.web
}

# provisioner "local-exec" {
#   command = "ansible-playbook -i inventory web.yaml"
# }

provisioner "local-exec"{
    when = destroy
    command = "echo this will execute at the time of destroy,you can triigger other system like email and sending alerts"
    
}
connection {
  type = "ssh"
  user = "centos"
  password = "DevOps321"
  host = self.public_ip
}

provisioner "remote-exec" {
  inline = [ 
    "echo 'this is from remote exec' > /tmp/remote.txt",
    "sudo yum install nginx -y",
    "sudo systemctl start nginx"

   ]
}
}

resource "aws_security_group" "roboshop-all" { #this is terraform name,for terraform
    name        = "provisioner"


    ingress {
        description       = "allow all ports"
        from_port         = 22
        protocol          = "tcp"
        to_port           = 22
        cidr_blocks       = ["0.0.0.0/0"]
     
    }
    ingress {
        description       = "allow all ports"
        from_port         = 80
        protocol          = "tcp"
        to_port           = 80
        cidr_blocks       = ["0.0.0.0/0"]
     
    }
    
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
  }
}