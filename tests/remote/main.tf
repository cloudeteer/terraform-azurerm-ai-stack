# specify dependencies for remote module tests here
resource "random_pet" "this" {}

output "random_pet" {
  value = random_pet.this.id
}
