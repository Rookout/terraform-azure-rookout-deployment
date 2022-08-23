module "rookout" {
    source  = "Rookout/rookout-deployment/azure"
    # version = x.y.z
    
    domain_name = "YOUR_DOMAIN"
    domain_resource_group = "DOMAIN'S_RESOUCRE_GROUP"

    rookout_token = "YOUR_TOKEN"
}