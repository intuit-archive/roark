module Roark
  module CLI
    module Shared
      def validate_required_options(options)
        options.each do |o|
          unless @options[o]
            raise OptionParser::MissingArgument.new "Option '#{o.to_s}' required."
          end
        end
      end

      def command_name
        self.class.name.split('::').last.downcase
      end

      def help
        puts option_parser.help
      end

      def aws
        Roark::Aws::Connection.new :access_key_id  => @options[:access_key_id],
                                   :aws_secret_key => @options[:secret_access_key],
                                   :region         => @options[:region]
      end
    end
  end
end
