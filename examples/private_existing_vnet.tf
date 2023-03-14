module "rookout" {
    source  = "Rookout/rookout-deployment/azure"
    # version = x.y.z
    
    rookout_token = "YOUR_TOKEN"
    internal = true

    create_vnet = false
    existing_vnet_name = "..."
    existing_vnet_resource_group_name = "..."

    subnet_app_serivce_cidr = "x.y.z.0/28"
    private_endpoint_subnet_cidr ="x.y.z.64/28"
}