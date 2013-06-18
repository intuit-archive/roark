module Roark
  module CLI
    module Shared
      def validate_required_options(options)
        options.each do |o|
          unless @options[o]
            @logger.error "Option '#{o.to_s}' required."
            exit 1
          end
        end
      end

      def validate_account_ids_format
        @options[:account_ids].each do |a|
          unless a =~ /^[0-9]{12}$/
            @logger.error "Account IDs must be 12 digits without dashes."
            exit 1
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
