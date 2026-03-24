terraform {
  required_version = ">= 1.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    vercel = {
      source  = "vercel/vercel"
      version = "~> 4.0"
    }
  }
}
