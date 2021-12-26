require 'rest-client'
require 'base64'
require 'json'
require_relative './speed_tester'
require_relative './log'

class Subscription
  include SpeedTester

  def initialize(url)
    @url = url
  end

  def available_nodes(speed_testing)
    return contents unless speed_testing
    Log.ok "top3 nodes: #{available_node_names}"
    contents.filter{ |node| available_node_names.include?(" ^#{node['ps']}") }
  end

  private

  attr_reader :url

  def contents
    @contents ||= Base64.decode64(row_content).split("\n").filter(&vmess?).map(&vmess_parser)
  end

  def vmess?
    lambda { |subscription_url| subscription_url.start_with?('vmess://') }
  end

  def vmess_parser
    lambda { |subscription_url| JSON.parse(Base64.decode64(subscription_url.sub('vmess://', ''))) }
  end

  def row_content
    Log.warning('fetching configurations from subscription url...')
    @row_content ||= RestClient.get(url).body
  end
end
