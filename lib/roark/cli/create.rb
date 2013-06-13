module Roark
  module CLI
    class Create

      include Shared

      def initialize
        @options = {}
      end

      def create
        option_parser.parse!

        validate_required_options [:name, :parameters, :region, :template, :aws_access_key, :aws_secret_key]

        template   = File.read @options[:template]

        aws = Roark::Aws::Connection.new :access_key_id  => @options[:access_key_id],
                                         :aws_secret_key => @options[:secret_access_key],
                                         :region         => @options[:region]

        image = Roark::Image.new :aws  => aws,
                                 :name => @options[:name]

        image.create :template   => template,
                     :parameters => parse_parameters(@options[:parameters])
      end

      def option_parser
        OptionParser.new do |opts|
          opts.banner = "Usage: roark create [options]"

          opts.on("-n", "--name [NAME]", "Name of image") do |o|
            @options[:name] = o
          end

          opts.on("-p", "--parameters [PARAMETERS]", "CSV of parameters and values separated by '=' to pass to Cloud Fomration") do |o|
            @options[:parameters] = o
          end

          opts.on("-r", "--region [REGION]", "Region to build image") do |o|
            @options[:region] = o
          end

          opts.on("-t", "--template [TEMPLATE]", "Path to Cloud Formation template") do |o|
            @options[:template] = o
          end

          opts.on("--aws-access-key [KEY]", "AWS Access Key") do |o|
            @options[:aws_access_key] = o
          end

          opts.on("--aws-secret-key [KEY]", "AWS Secret Key") do |o|
            @options[:aws_secret_key] = o
          end
        end
      end

      def parse_parameters(parameters)
        p = {}
        parameters.split(',').each do |attribs|
          key   = attribs.split('=').first.gsub(/\s+/, "")
          value = attribs.gsub(/^.+?=/, '')
          p[key] = value
        end
        p
      end

      def command_summary
        'Creates a images'
      end

    end
  end
end
