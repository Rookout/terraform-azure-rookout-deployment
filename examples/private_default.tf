module "rookout" {
    source  = "Rookout/rookout-deployment/azure"
    # version = x.y.z
    
    rookout_token = "YOUR_TOKEN"
    internal = true
}