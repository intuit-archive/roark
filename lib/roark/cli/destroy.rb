module Roark
  module CLI
    class Destroy

      include Shared

      def initialize
        @options = {}
      end

      def destroy
        option_parser.parse!

        validate_required_options [:ami_id, :region]

        ami = Roark::Ami.new :aws => aws, :ami_id => @options[:ami_id]

        response = ami.destroy
        unless response.success?
          Roark.logger.error response.message
          exit 1
        end
      end

      def option_parser
        OptionParser.new do |opts|
          opts.banner = "Usage: roark destroy [options]"

          opts.on("-i", "--ami-id [AMI_ID]", "ID of AMI to destroy") do |o|
            @options[:ami_id] = o
          end

          opts.on("-r", "--region [REGION]", "Region to build AMI") do |o|
            @options[:region] = o
          end

          opts.on("--aws-access-key [KEY]", "AWS Access Key") do |o|
            @options[:aws_access_key] = o
          end

          opts.on("--aws-secret-key [KEY]", "AWS Secret Key") do |o|
            @options[:aws_secret_key] = o
          end
        end
      end

      def command_summary
        'Destroys an AMI'
      end

    end
  end
end
