## Rancher2 settings

# the URL of the Rancher2 server
rancher2_url = ""

# Rancher 2 API access key for a user who can create clusters, you can login on Rancher2 and create from the "API & Keys" menu on your account or the URL /apikeys
rancher2_access_key = ""

# Rancher 2 API secret key for a user who can create clusters, you can login on Rancher2 and create from the "API & Keys" menu on your account or the URL /apikeys
rancher2_secret_key = ""

# AWS Provider settings
# AWS region
aws_region = "us-east-1"

# AWS access key
aws_access_key_id = ""

# AWS secret key
aws_secret_access_key = ""

# Quay Registry settings
# quay user name
quay_user = ""

# quay user password
quay_password = ""

# quay url in docker registry format, defaults to "quay.io"
quay_url = "quay.io"

# Stack configuration settings

# name of your project
project_name = "aae"

# name of your environment like dev/staging/prod
project_environment = "dev"

# name for your cluster, if not set it will be a concatenation of project_name and project_environment
cluster_name = ""

# description for your cluster
cluster_description = ""

# AWS Route53 Settings

# AWS Route53 zone domain
zone_domain = ""

# AAE/AAE settings

# location of your AAE license file
aae_license = "~/Downloads/activiti.lic"

# ssh username and public key to authenticate eks-cluster nodes
ssh_username = "aae"

ssh_public_key = ""

# Kubernetes deployment settings (automatically generated, do not modify)

