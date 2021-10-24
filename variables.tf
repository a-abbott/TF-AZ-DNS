# Creator : Alexander Abbott
# Source  : https://github.com/a-abbott/TF-AZ-DNS

# TF Values
#   These are values for terraform to use in the deployment.

    variable "tf_required_version" {
        type = string
        # The version of terraform to be used for this deployment
        default = ">= 1.0.0"
    }
    variable "tf_az_provider_source" {
        type = string
        # The source of the terraform provider
        default = "hashicorp/azurerm"
    }
    variable "tf_az_provider_version" {
        type = string
        # The version of the terraform provider
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

# AZ DNS Deployment Values
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
        variable "custom_soa" {
            # Required : email, host_name
            # Optional : expire_time, fqdn, minimum_ttl, refresh_time, retry_time, serial_number, ttl
            # Time units : Seconds
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
    variable "enable_custom_tiemouts" {
        type = bool
        # If set to true, enable configuration for custom timeouts"
        default = false
    }
    # If "enable_custom_timeouts" set to true, complete the following variables
        variable "timeouts" {
            # Optional : create, delete, read, update
            # Time units : Minutes
            type = set(object(
                {
                create = string
                delete = string
                read   = string
                update = string
                }
            ))
            default = [
                {
                    create = ""
                    delete = ""
                    read   = ""
                    update = ""
                }
            ]
        }
# AZ DNS Record Config Values
#   These are values for use configuring records the AZ DNS zone
        # Create A Records
            variable "enable_a_record_creation" {
                type = bool
                # If set to true, enable A Records"
                default = false
            }
            # If "enable_a_record_creation" set to true, complete the following variables
                variable "a_records" {
                    type          = list(any)
                    description   = "(Optional) Specifies a list of A records to create in the specified DNS zone."
                    # Example of config for A record creation.
                    # To add multiple, repeate block, with a comma seperating.
                    /*
                    default = [
                        {
                            name    = "www"
                            records = ["192.168.0.1"]
                            ttl     = 3600
                        },
                        {
                            name    = "dev"
                            records = ["192.168.0.1"]
                            ttl     = 3600
                        }
                    ]
                    */
                    default = []
                }
        # Create AAAA Records
            variable "enable_aaaa_record_creation" {
                type = bool
                # If set to true, enable AAAA Records"
                default = false
            }
            # If "enable_aaaa_record_creation" set to true, complete the following variables
                variable "aaaa_records" {
                    type          = list(any)
                    description   = "(Optional) Specifies a list of AAAA records to create in the specified DNS zone."
                    # Example of config for AAAA record creation.
                    # To add multiple, repeate block, with a comma seperating.
                    /*
                    default = [
                        {
                            name    = "www"
                            records = ["2001:db8::1:0:0:1"]
                            ttl     = 3600
                        },
                        {
                            name    = "dev"
                            records = ["2001:db8::1:0:0:2"]
                            ttl     = 3600
                        }
                    ]
                    */
                    default = []
                }
        # Create CAA Records
            variable "enable_caa_record_creation" {
                type = bool
                # If set to true, enable CAA records"
                default = false
            }
            # If "enable_caa_record_creation" set to true, complete the following variables
                variable "caa_record_ttl" {
                    type = string
                    # The ttl for the MX record
                    default = "300" 
                }
                variable "caa_records" {
                    type          = list(any)
                    description   = "(Optional) Specifies a list of CAA records to create in the specified DNS zone."
                    # Example of config for CAA record creation.
                    # To add multiple, repeate block, with a comma seperating.
                    /*
                    default = [
                        {
                            flags   = "0"
                            tag     = "issue"
                            value   = "example.com"
                        }
                    ]
                    */
                    default = []
                }
        # Create CNAME Records
            variable "enable_cname_record_creation" {
                type = bool
                # If set to true, enable CNAME Records"
                default = false
            }
            # If "enable_a_record_creation" set to true, complete the following variables
                variable "cname_records" {
                    type          = list(any)
                    description   = "(Optional) Specifies a list of CNAME records to create in the specified DNS zone."
                    # Example of config for CNAME record creation.
                    # To add multiple, repeate block, with a comma seperating.
                    /*
                    default = [
                        {
                            name    = "www"
                            record  = "example.com"
                            ttl     = 3600
                        }
                    ]
                    */
                    default = []
                }
        # Create MX Record
            variable "enable_mx_record_creation" {
                type = bool
                # If set to true, enable MX records"
                default = false
            }
            # If "enable_MX_record_creation" set to true, complete the following variables
                variable "mx_record_name" {
                    type = string
                    # The name for the MX record
                    default = "" 
                }
                variable "mx_record_ttl" {
                    type = string
                    # The ttl for the MX record
                    default = "300" 
                }
                variable "mx_records" {
                    type               = list(any)
                    description        = "(Optional) Specifies a list of MX records to create in the specified DNS zone."
                    # Example of config for MX record creation.
                    # To add multiple, repeate block, with a comma seperating.
                    /*
                    default = [
                        {
                            preference = "10"
                            exchange   = "mail1.example.com"
                        }
                    ]
                    */
                    default = []
                }
        # Create NS Records
            variable "enable_ns_record_creation" {
                type = bool
                # If set to true, enable NS records"
                default = false
            }
            # If "enable_ns_record_creation" set to true, complete the following variables
                variable "ns_record_name" {
                    type = string
                    # The name for the NS record
                    default = "" 
                }
                variable "ns_record_ttl" {
                    type = string
                    # The ttl for the NS record
                    default = "300" 
                }
                variable "ns_record" {
                    type = string
                    # The content for the NS record. For multiple, seperate with comma.
                    default = ""
                }
        # Create PTR Record
            variable "enable_ptr_record_creation" {
                type = bool
                # If set to true, enable PTR records"
                default = false
            }
            # If "enable_ptr_record_creation" set to true, complete the following variables
                variable "ptr_record_name" {
                    type = string
                    # The name for the PTR record
                    default = "" 
                }
                variable "ptr_record_ttl" {
                    type = string
                    # The ttl for the PTR record
                    default = "300" 
                }
                variable "ptr_record" {
                    type = string
                    # The content for the PTR record. For multiple, seperate with comma.
                    default = ""
                }
# Deployment tags
    # These are tags to attach to all deployed assets.
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

# Extra tags
    variable "extra_tags" {
        type = object({
            exampletag = string
        })
        default = {
            exampletag = "example content"
        }
    }