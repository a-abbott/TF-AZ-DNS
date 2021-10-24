# Creator : Alexander Abbott
# Source  : https://github.com/a-abbott/TF-AZ-DNS

# Set TF Versions and providers
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

# Hold Azure RM data for TF
    data "azurerm_client_config" "current" {}

# Configure the Microsoft Azure Provider and subscription
    provider "azurerm" {
        features {}
        subscription_id = var.azure_subscription_id
    }

# Configure Tags
    locals {
        static_tags = {
            CreatedDate  = timestamp()
            ModifiedDate = timestamp()
        }
        common_tags = var.common_tags
        extra_tags  = var.extra_tags
    }

# Create Resouce Group
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

# Create AZ DNS Zone
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
        resource "timeouts" {
            count = var.enable_custom_tiemouts ? 1 : 0
            for_each = var.timeouts
            content {
                create = timeouts.value["create"]
                delete = timeouts.value["delete"]
                read = timeouts.value["read"]
                update = timeouts.value["update"]
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
        resource "timeouts" {
            count = var.enable_custom_tiemouts ? 1 : 0
            for_each = var.timeouts
            content {
                create = timeouts.value["create"]
                delete = timeouts.value["delete"]
                read = timeouts.value["read"]
                update = timeouts.value["update"]
            }
        }
        lifecycle {
        ignore_changes = [
            tags["CreatedDate"]
        ]
        }
        tags = merge(local.static_tags,var.common_tags, var.extra_tags)
    }
    
# Create AZ DNS Records
    # Create A Records
        resource "azurerm_dns_a_record" "a_record" {
            count = var.enable_a_record_creation ? 0 : 1
            zone_name           = var.domain
            resource_group_name = "${var.deployment_name}_rg"
            name                = var.a_records[count.index].name
            records             = var.a_records[count.index].records
            ttl                 = var.a_records[count.index].ttl
        }
    # Create AAAA Records
        resource "azurerm_dns_aaaa_record" "aaaa_record" {
            count = var.enable_aaaa_record_creation ? 0 : 1
            zone_name           = var.domain
            resource_group_name = "${var.deployment_name}_rg"
            name                = var.aaaa_records[count.index].name
            records             = var.aaaa_records[count.index].records
            ttl                 = var.aaaa_records[count.index].ttl
        }
    # Create CAA Records
        resource "azurerm_dns_caa_record" "caa_record" {
            count = var.enable_caa_record_creation ? 0 : 1
            zone_name           = var.domain
            resource_group_name = "${var.deployment_name}_rg"
            ttl                 = var.caa_record_ttl
            record {
                flags           = var.caa_records[count.index].flags
                tag             = var.caa_records[count.index].tag
                value           = var.caa_records[count.index].value
            }
        }
    # Create CNAME Records
        resource "azurerm_dns_cname_record" "cname_record" {
            count = var.enable_cname_record_creation ? 0 : 1
            zone_name           = var.domain
            resource_group_name = "${var.deployment_name}_rg"
            name                = var.cname_records[count.index].name
            records             = var.cname_records[count.index].record
            ttl                 = var.cname_records[count.index].ttl
        }
    # Create MX Records
        resource "azurerm_dns_mx_record" "mx_record" {
            count = var.enable_mx_record_creation ? 0 : 1
            zone_name           = var.domain
            resource_group_name = "${var.deployment_name}_rg"
            name                = var.mx_record_name
            ttl                 = var.mx_record_ttl
            record {
                preference      = var.mx_records[count.index].preference
                exchange        = var.mx_records[count.index].exchange
            }
        }
    # Create NS Records

        resource "azurerm_dns_ns_record" "ns_record" {
            count = var.enable_ns_record_creation ? 0 : 1
            zone_name           = var.domain
            resource_group_name = "${var.deployment_name}_rg"
            name                = var.ns_record_name
            ttl                 = var.ns_record_ttl
            records             = var.ns_record
        }
    # Create PTR Records
        resource "azurerm_dns_ptr_record" "example" {
            count = var.enable_ptr_record_creation ? 0 : 1
            zone_name           = var.domain
            resource_group_name = "${var.deployment_name}_rg"
            name                = var.ptr_record_name
            ttl                 = var.ptr_record_ttl
            records             = var.ptr_record
        }
    # Create SRV Records
        /*
        resource "azurerm_dns_srv_record" "example" {
            name                = "test"
            zone_name           = var.domain
            resource_group_name = "${var.deployment_name}_rg"
            ttl                 = 300
            record {
                priority = 1
                weight   = 5
                port     = 8080
                target   = "target1.contoso.com"
            }
        }
        */
    # Create TXT Records
        /*
        resource "azurerm_dns_txt_record" "example" {
            name                = "test"
            zone_name           = var.domain
            resource_group_name = "${var.deployment_name}_rg"
            ttl                 = 300
            record {
                value = "google-site-authenticator"
            }
            record {
                value = "more site information here"
            }
        }
        */
