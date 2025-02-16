provider "aws" {

    region = "us-east-1"

}

resource "aws_instance" "JenkinsServer" {

    ami                 = "ami-04b4f1a9cf54c11d0"
    instance_type       = "t2.medium"
    key_name            = "keypair2025"
    user_data           = file("scripts/jenkins.sh") 

    tags = {
        Name = "jenkins_server"
    }
  
}

resource "aws_instance" "Webserver" {

    ami                 = "ami-04b4f1a9cf54c11d0"
    instance_type       = "t2.micro"
    key_name            = "keypair2025"
    user_data           = file("scripts/nginx.sh") 

    tags = {
        Name = "nginx_server"
    }
  
}

resource "aws_instance" "tomcat" {

    ami                 = "ami-04b4f1a9cf54c11d0"
    instance_type       = "t2.micro"
    key_name            = "keypair2025"
    user_data           = file("scripts/tomcat.sh") 

    tags = {
        Name = "tomcat_server"
    }
  
}

resource "aws_instance" "mongodb" {

    ami                 = "ami-04b4f1a9cf54c11d0"
    instance_type       = "t2.micro"
    key_name            = "keypair2025"
    user_data           = file("scripts/mongod.sh") 

    tags = {
        Name = "mongod_server"
    }
  
}

