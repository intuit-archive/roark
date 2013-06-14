module Roark
  module Aws
    class Connection

      attr_accessor :region

      def initialize(args)
        @access_key_id     = args[:access_key_id]
        @secret_access_key = args[:secret_access_key]
        @region            = args[:region]
      end

      def cf
        @cf ||= AWS::CloudFormation.new :access_key_id     => @access_key_id,
                                        :secret_access_key => @secret_access_key,
                                        :region            => @region
      end

      def ec2
        @ec2 ||= AWS::EC2.new :access_key_id     => @access_key_id,
                              :secret_access_key => @secret_access_key,
                              :region            => @region
      end

    end
  end
end
