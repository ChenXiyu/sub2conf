require 'inifile'

module SpeedTester
  private

  SPEEDTESTER_PATH = '/opt/stairspeedtest'
  SPEEDTESTER = "#{SPEEDTESTER_PATH}/stairspeedtest"
  TEST_RESULT_DEST = '/tmp/result.ini'

  def start_test
    `yes | #{SPEEDTESTER} /u #{url} /g ' ' && mv #{SPEEDTESTER_PATH}/results/*.log #{TEST_RESULT_DEST}`
  end

  def parse_result
    IniFile.load("#{TEST_RESULT_DEST}").to_h
  end

  def test_results
    return @test_results unless @test_results.nil?

    start_test
    @test_results = parse_result.filter do |section, detials|
      detials['Online']
    end
  end
end
