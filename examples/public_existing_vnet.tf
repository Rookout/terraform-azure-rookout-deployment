module "rookout" {
    source  = "Rookout/rookout-deployment/azure"
    # version = x.y.z
    
    domain_name = "YOUR_DOMAIN"
    domain_resource_group = "DOMAIN'S_RESOUCRE_GROUP"

    rookout_token = "YOUR_TOKEN"

    create_vnet = false
    existing_vnet_name = "..."
    existing_vnet_resource_group = "..."

    subnet_app_serivce_cidr = "x.y.z.0/28"
    private_endpoint_subnet_cidr ="x.y.z.64/28"
}