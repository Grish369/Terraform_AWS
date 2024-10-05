terraform {
  backend "local" {
    path         = "terraform.tfstate"        # Local state file ka path
    workspace_dir = "terraform/workspaces"     # Directory for workspace state files
  }
}
