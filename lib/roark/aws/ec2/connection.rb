module Roark
  module Aws
    module Ec2
      class Connection
        def connect(aws)
          AWS::EC2.new aws
        end
      end
    end
  end
end
