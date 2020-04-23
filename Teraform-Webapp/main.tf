resource "azurerm_resource_group" "resource_group" {
  name     = "${var.prefix}-rg"
  location = ""${var.location}"
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "${var.prefix}-plan"
  location            = "${var.location}"
  resource_group_name = "${var.prefix}-rg"

  # Define Linux as Host OS
  kind = "Linux"

  # Choose size
  sku {
    tier = "Standard"
    size = "S1"
  }

  properties {
    reserved = true # Mandatory for Linux plans
  }
}

# Create an Azure Web App for Containers in that App Service Plan
resource "azurerm_app_service" "dockerapp" {
  name                = "${var.prefix}-dockerapp"
  location            = "${var.location}"
  resource_group_name = "${var.prefix}-rg"
  app_service_plan_id = "${azurerm_app_service_plan.appserviceplan.id}"

  # Do not attach Storage by default
  app_settings {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  }

  # Configure Docker Image to load on start
  site_config {
    linux_fx_version = "COMPOSE|${filebase64("petclinic-compose.yml")}"
    always_on        = "true"
  }

  identity {
    type = "SystemAssigned"
  }
}
