terraform {
  backend "kubernetes" {
    secret_namespace   = "terraform-state"       # (Required) The Kubernetes namespace to store the secret.
    secret_name        = "terraform-state-file"  # (Required) The name of the Kubernetes secret.
    
    # Optional arguments
    config_path        = "~/.kube/config"        # Path to the kubeconfig file for Kubernetes access.
    load_config_file   = true                    # Whether to load the kubeconfig file.
    in_cluster_config  = false                   # Use in-cluster configuration (for deployments inside the cluster).
    host               = "https://my-k8s-server.com"  # Custom Kubernetes API server URL.
    username           = "admin"                 # Username to authenticate with the Kubernetes API.
    password           = "mypassword"            # Password to authenticate with the Kubernetes API.
    client_certificate = "path/to/client.crt"    # Client certificate file for authentication.
    client_key         = "path/to/client.key"    # Client key file for authentication.
    cluster_ca_certificate = "path/to/ca.crt"    # CA certificate file for verifying the Kubernetes API server.
    token              = "my-k8s-token"          # Bearer token for Kubernetes API authentication.
  }
}
