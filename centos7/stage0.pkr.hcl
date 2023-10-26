packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable "docker_image" {
  type    = string
  default = "centos"
}

variable "docker_tag" {
  type    = string
  default = "7"
}

source "docker" "os" {
  image  = "${var.docker_image}:${var.docker_tag}"
  commit = true
}

build {
  name = "stage0"
  sources = [
    "source.docker.os",
  ]

  // output into file
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }

  // provisioner "shell" {
  //   inline = ["echo Running ${var.docker_image} Docker image."]
  // }

  post-processor "docker-tag" {
    repository = "${build.name}"
    // tags       = [""]  // if no tag, will auto use latest
    only = ["docker.os"]
  }

}
