# The "setup" test:
# - loads terraform.tf to set the required versions for following tests
# - to prepare dependencies to be used in the remote module tests
run "setup" {
  command = apply

  module {
    source = "./tests/remote"
  }
}

run "should_succeed_with_default_variable_values" {
  command = apply
}
