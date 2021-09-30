# NewRelic

Terraform sample to create IAM Role for New Relic AWS Integration.

# Quickstart

1. [Create New Relic Account](https://newrelic.com/signup)

2. Select Tab > Infrastructure > AWS

3. Select API Polling and then external id would be generated for IAM Role

4. Initialize Terraform 

```
terraform init
```

5. Apply terraform to create IAM resources for New Relic Integration

enter the external id which was generated previous step

```
terraform apply
var.externalID
  Enter a value: 
```
