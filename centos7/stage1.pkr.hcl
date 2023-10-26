packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

// pull what image
variable "docker_image" {
  type    = string
  default = "centos"
}

// with what tag
variable "docker_tag" {
  type    = string
  default = "7"
}

source "docker" "os" {
  image  = "${var.docker_image}:${var.docker_tag}"
  commit = true
}

build {
  name = "stage1"
  sources = [
    "source.docker.os",
  ]

  provisioner "shell-local" {
    inline = ["docker cp stage0:/example.txt stage1:/"]
  }

  provisioner "shell" {
    inline = ["echo Running ${var.docker_image} Docker image."]
  }

  post-processor "docker-tag" {
    repository = "${build.name}"
    // tags       = [""]  // if no tag, will auto use latest
    only = ["docker.os"]
  }

}
