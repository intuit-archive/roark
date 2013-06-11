module Roark
  module Aws
    module Ec2
      class Connect
        def initialize(args)
          @account = args[:account]
          @region  = args[:region]
        end

        def connect
          AWS::EC2.new :access_key_id     => access_key_id,
                       :secret_access_key => secret_access_key,
                       :region            => @region
        end

        private

        def access_key_id
          @account.access_key
        end

        def secret_access_key
          @account.secret_key
        end

      end
    end
  end
end
