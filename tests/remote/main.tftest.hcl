# The "setup" test:
# - loads terraform.tf to set the required versions for following tests
# - to prepare dependencies to be used in the remote module tests
run "setup" {
  command = apply

  module {
    source = "./tests/remote"
  }
}

run "should_apply_lowest_required_version_without_error" {
  command = apply

  variables {
    # access setup output
    example_variable = run.setup.random_pet
  }

  assert {
    condition     = output.example_output == run.setup.random_pet
    error_message = "Output example_output not equal to expected value"
  }
}
