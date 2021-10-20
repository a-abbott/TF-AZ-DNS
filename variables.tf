#Creator : Alexander Abbott
#Source  : https://github.com/a-abbott/TF-AZ-DNS

# Deployment Values
#   These are values for common use in the deployment.

    variable "Deployment_name" {
        type = string
        # The name to be used for this deployment. This will be used to name the following
        #   Resource groups (Assets, and Terraform State)
        #   Assets created within produced RG's
        default = "YOUR RG NAME"
    }
    variable "Location" {
        type = string
        # Where the RG should be created. All assets in this pipeline will be deployed here
        # Valid choices for your subscription can be found via "az account list-locations", using the AzureCLI.
        default = "UK South" 
    }

#AZ DNS Deployment Values
#   These are values for use creating the AZ DNS zone


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