require 'erb'

class V2rayConfig
  attr_reader :raw_outbounds

  CONFIG_TEMPLATE = File.join(File.dirname(__FILE__), '../templates/config.json.erb')

  def initialize(raw_outbounds)
    @raw_outbounds = raw_outbounds
  end

  def render
    ERB.new(File.read(CONFIG_TEMPLATE)).result(binding)
  end

  private

  def outbounds
    raw_outbounds.map do |raw_outbound|
      {
        'address' => raw_outbound['add'],
        'id' => raw_outbound['id'],
        'port' => raw_outbound['port'],
        'alter_id' => raw_outbound['aid'],
        'network' => raw_outbound['net'],
        'lts'=> raw_outbound['lts'],
        'ws'=> {
          'host' => raw_outbound['host'],
          'path' => raw_outbound['path'],
        }
      }
    end
  end

  def addresses
    @addresses ||= outbounds.map {|outbound| outbound['address']}.uniq
  end
end
