module Roark
  module Aws
    module CloudFormation
      class StackOutputs

        def initialize(connection)
          @connection = connection
        end

        def outputs(name)
          @connection.stacks[name].outputs
        end

      end
    end
  end
end
