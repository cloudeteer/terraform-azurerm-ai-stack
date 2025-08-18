mock_provider "azapi" { source = "tests/local/mocks" }
mock_provider "azurerm" { source = "tests/local/mocks" }

run "should_succeed_with_default_variable_values" {
  command = plan
}

run "should_fail_with_too_long_basename" {
  command = plan
  variables {
    basename = "this-is-a-long-name-with-no-borders"
  }
  expect_failures = [var.basename]
}
