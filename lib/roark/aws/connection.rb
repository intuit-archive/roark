module Roark
  module Aws
    class Connection

      attr_accessor :access_key_id, :secret_access_key, :region

      def initialize(args)
        @access_key_id     = args[:aws_access_key]
        @secret_access_key = args[:aws_secret_key]
        @region            = args[:region]
      end

    end
  end
end
