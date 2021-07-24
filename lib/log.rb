require 'colorize'

class Log
  class << self
    message_color_mapping = {
      :warning => :yellow,
      :info => :white,
      :error => :red,
      :ok => :green
    }

    message_color_mapping.each do |message_type, color|
      define_method message_type do |message|
        output message.colorize(color)
      end
    end

    private

    def output(message)
      STDERR.puts message
    end
  end
end
