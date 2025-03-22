resource "aws_key_pair" "my_key" {
    key_name   = "my_key"
    public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "web_server" {
    ami           = "ami-053b0d53c279acc90" 
    instance_type = "t2.micro" 
    subnet_id = aws_subnet.public.id
    key_name = aws_key_pair.my_key.key_name
    
    user_data = <<-EOF
                            #!/bin/bash
                            sudo apt update -y
                            sudo apt install apache2 -y
                            EOF



    vpc_security_group_ids = [aws_security_group.web_sg.id]
}


terraform {
  backend "s3" {
    bucket         = "gio73bucket"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}


