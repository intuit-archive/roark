module Roark
  module Aws
    module Ec2
      module Connection
        def connect(args)
          AWS::EC2.new :access_key_id     => args[:aws_access_key],
                       :secret_access_key => args[:aws_secret_key],
                       :region            => args[:region]
        end
      end
    end
  end
end
