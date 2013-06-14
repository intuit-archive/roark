module Roark
  module CLI
    class Destroy

      include Shared

      def initialize
        @options = {}
      end

      def destroy
        option_parser.parse!

        validate_required_options [:image_id, :region]

        image = Roark::Image.new :aws => aws, :image_id => @options[:image_id]

        response = image.destroy
        unless response.success?
          Roark.logger.error response.message
          exit 1
        end
      end

      def option_parser
        OptionParser.new do |opts|
          opts.banner = "Usage: roark destroy [options]"

          opts.on("-i", "--image-id [IMAGE_ID]", "ID of Image to destroy") do |o|
            @options[:image_id] = o
          end

          opts.on("-r", "--region [REGION]", "Region to build image") do |o|
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
        'Destroys a images'
      end

    end
  end
end
