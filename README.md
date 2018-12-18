# frontend-tools

Exploration into some tooling for the GDS frontend community.

## How to use

Dependencies:

```
brew install tfenv
tfenv use 0.11.10
```

## How to deploy

```
# Example for the testing deployment

cd terraform/deployments/testing
terraform init
terraform apply -var office_cidrs=1.2.3.4/32
```
