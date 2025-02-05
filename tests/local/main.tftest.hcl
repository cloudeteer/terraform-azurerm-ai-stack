mock_provider "azapi" { source = "tests/local/mocks" }
mock_provider "azurerm" { source = "tests/local/mocks" }

run "should_succeed_with_default_variable_values" {
  command = plan
}
