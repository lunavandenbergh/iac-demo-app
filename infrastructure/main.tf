resource "azurerm_resource_group" "example" {
  name     = "loens-rg"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "loenstoracc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "example" {
  name                  = "loenscontainer"
  container_access_type = "private"
  storage_account_name  = azurerm_storage_account.example.name
}

resource "azurerm_storage_blob" "example" {
  name                   = "mailfunction.zip"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type                   = "Block"
  source                 = "mailfunction.zip"
}


resource "azurerm_app_service_plan" "example" {
  name                = "api-appserviceplan-pro"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_windows_function_app" "example" {
  name                = "example-windows-function-app"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  service_plan_id            = azurerm_app_service_plan.example.id

  site_config {}

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.example.name}.blob.core.windows.net/${azurerm_storage_container.example.name}/${azurerm_storage_blob.example.name}?${azurerm_storage_account.example.primary_access_key}"
  }
}