module Roark
  module CLI
    class Create

      def initialize
        @options = {}
      end

      def option_parser
        OptionParser.new do |opts|
          opts.banner = "Usage: roark create [options]"

          opts.on("-n", "--name [NAME]", "Name of Image") do |n|
            @options[:name] = n
          end
        end
      end

      def command_summary
        'Creates a images'
      end

      def command_name
        self.class.name.split('::').last.downcase
      end

      def help
        puts option_parser.help
      end
    end
  end
end
