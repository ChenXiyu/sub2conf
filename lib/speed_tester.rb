require 'inifile'
require_relative 'log'

module SpeedTester
  private

  SPEEDTESTER_PATH = '/opt/stairspeedtest'
  SPEEDTESTER = "#{SPEEDTESTER_PATH}/stairspeedtest"
  TEST_RESULT_DEST = '/tmp/result.ini'

  def start_test
    Log.warning "Speed testing started..."
    @start_test ||= `yes | #{SPEEDTESTER} /u #{url} /g ' ' 1>&2 && mv #{SPEEDTESTER_PATH}/results/*.log #{TEST_RESULT_DEST}`
    Log.ok "Speed testing complested!"
  end

  def parse_result
    IniFile.load("#{TEST_RESULT_DEST}").to_h
  end

  def available_node_names
    return @available_node_names unless @available_node_names.nil?
    start_test

    online_nodes = parse_result.filter(&online?)
    @available_node_names = top_3(online_nodes).map(&node_name)
  end

  def node_name
    lambda {|node| node.first }
  end

  def online?
    lambda {|_, details| details['Online']}
  end

  def top_3(nodes)
    nodes.to_a.sort_by {|node| to_KB(node.last["AvgSpeed"])}.reverse.slice(0...3)
  end

  def to_KB(rate)
    unit = rate.slice(-2...-1).downcase
    number = rate.slice(0...-2).to_f
    case unit
    when 'm'
      number * 1000
    when 'g'
      number * 1000 * 1000
    else
      number
    end
  end
end
