module Roark
  module CLI
    class Create

      include Shared

      def initialize
        @options = { :account_ids => [],
                     :parameters  => {},
                     :region      => 'us-east-1',
                     :tags        => {} }
        @logger  = Roark.logger
      end

      def create
        option_parser.parse!

        validate_required_options [:name, :cloud_formation_template]

        validate_account_ids_format

        unless File.exists? @options[:cloud_formation_template]
          @logger.error "Template #{@options[:cloud_formation_template]} does not exist."
          exit 1
        end

        cloud_formation_template = File.read @options[:cloud_formation_template]

        ami = Roark::Ami.new :aws => aws, :name => @options[:name]

        ami_create_workflow = Roark::AmiCreateWorkflow.new :account_ids => @options[:account_ids],
                                                           :ami         => ami,
                                                           :tags        => @options[:tags],
                                                           :template    => cloud_formation_template,
                                                           :parameters  => @options[:parameters]
        response = ami_create_workflow.execute

        unless response.success?
          @logger.error response.message
          exit 1
        end

        @logger.info response.message
      end

      def option_parser
        OptionParser.new do |opts|
          opts.banner = "Usage: roark create [options]"

          opts.on("-a", "--account_id [ACCOUNT_ID]", "AWS Account ID to Authorize. Can be specified multiple times.") do |o|
            @options[:account_ids] << o
          end

          opts.on("-c", "--cloud_formation_template [CLOUD_FORMATION_TEMPLATE]", "Path to Cloud Formation template") do |o|
            @options[:cloud_formation_template] = o
          end

          opts.on("-n", "--name [NAME]", "Name of AMI") do |o|
            @options[:name] = o
          end

          opts.on("-p", "--parameters [PARAMETERS]", "Parameter name and it's value separated by '=' to pass to Cloud Formation. Can be specified multiple times.") do |o|
            data = o.split('=')
            @options[:parameters].merge!({ data.first => data[1] })
          end

          opts.on("-r", "--region [REGION]", "Region to build AMI") do |o|
            @options[:region] = o
          end

          opts.on("-t", "--tag [TAG]", "AMI tag name and it's value separated by '='. Can be specified multiple times.") do |o|
            data = o.split('=')
            @options[:tags].merge!({ data.first => data[1] })
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
        'Creates an AMI'
      end

    end
  end
end
