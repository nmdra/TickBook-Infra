terraform {
  required_version = ">= 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    vercel = {
      source  = "vercel/vercel"
      version = "~> 1.0"
    }
  }
}
