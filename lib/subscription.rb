require 'rest-client'
require 'base64'
require 'json'
require_relative './speed_tester'
require 'pry'

class Subscription
  include SpeedTester

  def initialize(url)
    @url = url
  end

  def available_nodes
    available_node_names = test_results.keys
    contents.filter{ |node| available_node_names.include?(" ^#{node['ps']}") }
  end

  private

  attr_reader :url

  def contents
    Base64.decode64(row_content).split("\n").map do |vmess_address|
      next unless vmess_address.start_with?('vmess://')

      JSON.parse(Base64.decode64(vmess_address.sub('vmess://', '')))
    end.compact
  end

  def row_content
    @row_content ||= RestClient.get(url).body
  end
end
