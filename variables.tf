variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
    default = "ap-northeast-1"
}

variable "images" {
    type = "map"
    default = {
        "amazon_linux" = "ami-1a15c77b"
        "rhel7"        = "ami-0dd8f963"
        "ubuntu14_04"  = "ami-a21529cc"
        "windows_server_2016"      = "ami-df3f98be"
        "windows_server_container" = "ami-996bccf8"
        "windows_server_nano"      = "ami-7162c510"
    }
}

