#Creator : Alexander Abbott
#Source  : https://github.com/a-abbott/TF-AZ-DNS

# TF Values
#   These are values for terraform to use in the deployment.

    variable "tf_required_version" {
        type = string
        # The name to be used for this deployment. This will be used to name the following
        #   Resource groups (Assets, and Terraform State)
        #   Assets created within produced RG's
        default = ">= 1.0.0"
    }
    variable "tf_az_provider_source" {
        type = string
        # The name to be used for this deployment. This will be used to name the following
        #   Resource groups (Assets, and Terraform State)
        #   Assets created within produced RG's
        default = "hashicorp/azurerm"
    }
    variable "tf_az_provider_version" {
        type = string
        # The name to be used for this deployment. This will be used to name the following
        #   Resource groups (Assets, and Terraform State)
        #   Assets created within produced RG's
        default = "=2.73.0"
    }

# Deployment Values
#   These are values for common use in the deployment.

    variable "azure_subscription_id" {
        type = string
        # The azure subscription id to be used for this deployment.
        default = ""
    }

    variable "deployment_name" {
        type = string
        # The name to be used for this deployment. This will be used to name the following
        #   Resource groups (Assets, and Terraform State)
        #   Assets created within produced RG's
        default = "YOUR RG NAME"
    }

    variable "location" {
        type = string
        # Where the RG should be created. All assets in this pipeline will be deployed here
        # Valid choices for your subscription can be found via "az account list-locations", using the AzureCLI.
        default = "UK South" 
    }

#AZ DNS Deployment Values
#   These are values for use creating the AZ DNS zone
    variable "domain" {
        type = string
        # The domain this DNS zone represents.
        default = "UK South" 
    }
    variable "enable_private_dns" {
        type = bool
        # If set to true, enable private DNS"
        default = false
    }
    variable "enable_custom_soa" {
        type = bool
        # If set to true, enable configuration for custom SOA"
        default = false
    }

    # If "enable_custom_soa" set to true, complete the following variables
        variable "soa_record" {
            # Required : email, host_name
            # Optional : expire_time, fqdn, minimum_ttl, refresh_time, retry_time, serial_number, ttl
            type = set(object(
                {
                    email         = string
                    host_name     = string
                    expire_time   = number
                    fqdn          = string
                    minimum_ttl   = number
                    refresh_time  = number
                    retry_time    = number
                    serial_number = number
                    ttl           = number
                }
            ))
            default = [
                {
                    email         = ""
                    host_name     = ""
                    expire_time   = ""
                    fqdn          = ""
                    minimum_ttl   = ""
                    refresh_time  = ""
                    retry_time    = ""
                    serial_number = ""
                    ttl           = ""
                }
            ]
        }

#AZ DNS Record Config Values
#   These are values for use configuring records the AZ DNS zone

#Deployment tags
#   These are tags to attach to all deployed assets.
    variable "common_tags" {
        type = object({
            production = string
            project_name = string
            owner_name = string
        })
        default = {
            production = "TAG FOR IF THIS IS IN PRODUCTION"
            project_name = "TAG FOR THIS PROJECT"
            owner_name = "TAG FOR THE OWNER"
        }
    }

#Extra tags
    variable "extra_tags" {
        type = object({
            exampletag = string
        })
        default = {
            exampletag = "example content"
        }
    }