module Roark
  module Aws
    module CloudFormation
      class Connection
        def connect(args)
          AWS::CloudFormation.new :access_key_id     => args[:aws_access_key],
                                  :secret_access_key => args[:aws_secret_key],
                                  :region            => args[:region]
        end
      end
    end
  end
end
