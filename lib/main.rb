require 'clamp'
require_relative './subscription'
require_relative './v2ray_config'

Clamp do
  parameter 'SUBSCRIPTION_URL', 'The Url of v2ray subscription'

  def execute
    available_nodes = Subscription.new(subscription_url).available_nodes
    exit 1 if available_nodes.empty?
    puts V2rayConfig.new(available_nodes).render
  end
end
