module "rookout" {
    source  = "Rookout/rookout-deployment/azure"
    # version = x.y.z
    
    rookout_token = "YOUR_TOKEN"
    existing_resource_group_name = "..." # used for rookout deployment

    internal = true

    create_vnet = false
    existing_vnet_name = "..."
    existing_vnet_resource_group_name = "..."

    subnet_app_service_name = "..."
    private_endpoint_subnet_name = "..."
}