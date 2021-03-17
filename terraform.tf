terraform {
  backend "remote" {
    organization = "scaleworx"

    workspaces {
      prefix = "tw-"
    }
  }
}
