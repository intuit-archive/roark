module Roark
  module Aws
    module CloudFormation
      class Connection
        def connect(aws)
          AWS::CloudFormation.new aws
        end
      end
    end
  end
end
