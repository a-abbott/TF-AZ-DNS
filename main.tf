#Creator : Alexander Abbott
#Source  : https://github.com/a-abbott/TF-AZ-DNS

#Set TF Versions and providers
    terraform {
        required_version = var.tf_required_version
        backend "azurerm" {
        }
        required_providers {
            azurerm = {
                source  = var.tf_az_provider_source
                version = var.tf_az_provider_version
            }
        }
    }

#Hold Azure RM data for TF
    data "azurerm_client_config" "current" {}

#Configure the Microsoft Azure Provider and subscription
    provider "azurerm" {
        features {}
        subscription_id = var.azure_subscription_id
    }

#Configure Tags
    locals {
        static_tags = {
            CreatedDate  = timestamp()
            ModifiedDate = timestamp()
        }
        common_tags = var.common_tags
        extra_tags  = var.extra_tags
    }

#Create Resouce Group
    resource "azurerm_resource_group" "RG" {
        name     = "${var.deployment_name}_rg"
        location = var.location
        lifecycle {
        ignore_changes = [
            tags["CreatedDate"]
        ]
        }
        tags = merge(local.static_tags,var.common_tags, var.extra_tags)
    }

#Create AZ DNS

    resource "azurerm_dns_zone" "AZ_DNS_Zone" {
        count = var.enable_private_dns ? 1 : 0
        name                = var.domain
        resource_group_name = "${var.deployment_name}_rg"
        resource "soa_record" {
            count = var.enable_custom_soa ? 1 : 0
            for_each = var.custom_soa
            content {
                email = custom_soa.value["email"]
                host_name = custom_soa.value["host_name"]
                expire_time = custom_soa.value["expire_time"]
                minimum_ttl = custom_soa.value["minimum_ttl"]
                refresh_time = custom_soa.value["refresh_time"]
                retry_time = custom_soa.value["retry_time"]
                serial_number = custom_soa.value["serial_number"]
                tags = custom_soa.value["tags"]
                ttl = custom_soa.value["ttl"]
            }
        }
        lifecycle {
        ignore_changes = [
            tags["CreatedDate"]
        ]
        }
        tags = merge(local.static_tags,var.common_tags, var.extra_tags)
    }

    resource "azurerm_private_dns_zone" "AZ_DNS_Zone" {
        count = var.enable_private_dns ? 0 : 1
        name                = var.domain
        resource_group_name = "${var.deployment_name}_rg"
        resource "soa_record" {
            count = var.enable_custom_soa ? 1 : 0
            for_each = var.custom_soa
            content {
                email = custom_soa.value["email"]
                host_name = custom_soa.value["host_name"]
                expire_time = custom_soa.value["expire_time"]
                minimum_ttl = custom_soa.value["minimum_ttl"]
                refresh_time = custom_soa.value["refresh_time"]
                retry_time = custom_soa.value["retry_time"]
                serial_number = custom_soa.value["serial_number"]
                ttl = custom_soa.value["ttl"]
            }
        }
        lifecycle {
        ignore_changes = [
            tags["CreatedDate"]
        ]
        }
        tags = merge(local.static_tags,var.common_tags, var.extra_tags)
    }
    