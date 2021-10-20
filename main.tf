#Creator : Alexander Abbott
#Source  : https://github.com/a-abbott/TF-AZ-DNS

#Set TF Versions and providers
    terraform {
        required_version = ">= 1.0.0"
        backend "azurerm" {
        }
        required_providers {
            azurerm = {
                source  = "hashicorp/azurerm"
                version = "=2.73.0"
            }
        }
    }

#Hold Azure RM data for TF
    data "azurerm_client_config" "current" {}

#Configure the Microsoft Azure Provider and subscription
    provider "azurerm" {
        features {}
        subscription_id = "INSERTVARIABLEFORSUBID"
    }

#Configure Tags
    locals {
        static_tags = {
            CreatedDate = timestamp()
            ModifiedDate = timestamp()
        }
        common_tags = var.common_tags
        extra_tags = var.extra_tags
    }

#Create Resouce Group
    resource "azurerm_resource_group" "RG" {
        name     = var.RG_name
        location = var.Location
        lifecycle {
        ignore_changes = [
            tags["CreatedDate"]
        ]
        }
        tags     = merge(local.static_tags,var.common_tags, var.extra_tags)
    }

#Create AZ DNS