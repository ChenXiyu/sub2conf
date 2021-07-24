require 'clamp'
require_relative './subscription'
require_relative './v2ray_config'
require_relative './log'

Clamp do
  parameter 'SUBSCRIPTION_URL', 'The Url of v2ray subscription'

  def execute
    Log.warning "Conversion started..."
    available_nodes = Subscription.new(subscription_url).available_nodes
    exit_with "There is no available nodes" if available_nodes.empty?
    puts V2rayConfig.new(available_nodes).render
  end

  def exit_with(message)
    Log.error message
    exit 1
  end
end
