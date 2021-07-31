require 'clamp'
require_relative './subscription'
require_relative './v2ray_config'
require_relative './log'

Clamp do
  option '--subscription_url', 'SUBSCRIPTION_URL', 'The Url of v2ray subscription.', required: true
  option '--speed_testing', :flag, 'Run speed testing and filter nodes based on testing results.'
  option '--output', 'OUTPUT', 'The file name that the configuration needs to be write in.', required: true

  def execute
    Log.warning "Conversion from subscription url to v2ray configurations started..."
    available_nodes = Subscription.new(subscription_url).available_nodes(speed_testing?)
    exit_with "There is no available nodes" if available_nodes.empty?
    write_to(output, V2rayConfig.new(available_nodes).render)
    Log.ok "Conversion completed."
  end

  def exit_with(message)
    Log.error message
    exit 1
  end

  def write_to(file, content)
    File.open(file, 'w') do |f|
      f.write(content)
    end
  end
end
