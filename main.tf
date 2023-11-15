provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "docker-deploy-test-rg"{
  name = "dockerDeployTest"
}

resource "azurerm_service_plan" "docker-deploy-test-service-plan" {
  name                = "glasgow-digital-twin-service-plan"
  resource_group_name = data.azurerm_resource_group.docker-deploy-test-rg.name
  location            = data.azurerm_resource_group.docker-deploy-test-rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "docker-deploy-test" {
  name                = "docker-deploy-test"
  resource_group_name = data.azurerm_resource_group.docker-deploy-test-rg.name
  location            = azurerm_service_plan.docker-deploy-test-service-plan.location
  service_plan_id     = azurerm_service_plan.docker-deploy-test-service-plan.id

  site_config {
    application_stack {
      docker_image_name        = "node-hello-world:latest"
      docker_registry_url      = "https://dockerdeploytestacr.azurecr.io"
      docker_registry_username = "dockerdeploytestacr"
    }
  }
}
