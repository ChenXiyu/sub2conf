require 'clamp'
require_relative './subscription'
require_relative './v2ray_config'

Clamp do
  parameter 'SUBSCRIPTION_URL', 'The Url of v2ray subscription'

  def execute
    puts V2rayConfig.new(Subscription.new(subscription_url).available_nodes).render
  end
end
