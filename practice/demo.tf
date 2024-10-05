variable "lists" {
    default = ["a","b","c"]
    type= list(string)
}
provider "local" {
  
}
# main.tf
resource "local_file" "example" {
 
  for_each = toset(var.lists)  # Convert the list to a set for unique keys


    name = each.value  # Assign each item from the list to the "name" key
  
}

# Optionally, to output the names of the created resources:
output "resource_names" {
  value = [for r in local_file.example : r.triggers["name"]]
}
