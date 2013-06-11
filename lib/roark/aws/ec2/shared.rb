module Roark
  module Aws
    module Ec2
      module Shared
        def connect
          AWS::EC2.new :access_key_id     => aws_access_key,
                       :secret_access_key => aws_secret_key,
                       :region            => region
        end

        def aws_access_key
          @aws_access_key
        end

        def aws_secret_key
          @aws_secret_key
        end

        def region
          @region
        end
      end
    end
  end
end
