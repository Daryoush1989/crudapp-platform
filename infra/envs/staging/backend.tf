terraform {
  backend "s3" {
    bucket       = "cloud-dash-crudapp-platform-tfstate-969566116923-eu-west-2"
    key          = "envs/staging/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}