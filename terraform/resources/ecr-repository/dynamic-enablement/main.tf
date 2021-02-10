provider "aws" {
  alias = "us-east-2"
  region = "us-east-2"
}

module "dynamic-enablement" {
  providers = {
    aws = aws.us-east-2
  }
  source    =  "..\/..\/..\/..\/..\/SRE-Challenge-Fork\/SRE-Challenge\/terraform\/modules/ecr-repository"
  ecr_repository_name = "dynamic-enablement"

  common_tags = {
    Asset = "dynamic-enablement"
    ControlledBy = "terraform"
  }

}