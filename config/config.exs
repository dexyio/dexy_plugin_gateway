# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# 3rd party setting
config :dexy_plugin_gateway, DexyPluginGateway, %{
  # app_name => {process_name, node}
  "foo" => {:mailbox, :"gateway@127.0.0.1"}
}
