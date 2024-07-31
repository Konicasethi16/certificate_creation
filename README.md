# Create TLS certificates using Terraform and Let's encrypt
commit
Using this repo you can create valid certificates using terraform and let's encrypt

See manual [Create certificates](manual_creation/README.md) for manual steps.

# Prerequisites

## Install terraform  
See the following documentation [How to install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## AWS
We will be using AWS. Make sure you have the following

- AWS account

# How to
- Clone the repository to your local machine
```
git clone https://github.com/munnep/certificate_creation.git
```
- Go to the directory
```
cd certificate_creation
```
- create a file called `variables.auto.tfvars` with the following content
```
region                   = "ap-southeast-1"                   # region where to connect to
dns_hostname             = "patrick-tfe3-client"              # hostname for which to create the certificate
dns_zonename             = "tf-support.hashicorpdemo.com"     # domain name to create the certificate
certificate_email        = "patrick.munne@hashicorp.com"      # email address to be used while generating the certificates
```
- Set your AWS credentials
```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
```
- Initialize the directory
```
terraform init
```
- Create the certificates
```
terraform apply
```
- This should create 5 files under the directory `certificate_files/`. View the [README.md](certificate_files/README.md) in this directory for what each file is

```
├── certificate_files
│   ├── README.md
│   ├── certificate_p12.pfx
│   ├── certificate_pem.pem
│   ├── full_chain.pem
│   ├── issuer.pem
│   └── private_key.pem
```

