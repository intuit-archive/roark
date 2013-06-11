module Roark
  module Aws
    module CloudFormation
      class Connect
        def initialize(args)
          @account = args[:account]
          @region  = args[:region]
        end

        def connect
          AWS::CloudFormation.new :access_key_id     => @account.access_key,
                                  :secret_access_key => @account.secret_key,
                                  :region            => @region
        end
      end
    end
  end
end
