module Roark
  module Aws
    module CloudFormation
      class DestroyStack

        def initialize(connection)
          @connection = connection
        end

        def destroy(name)
          @connection.cf.stacks[name].delete
        end

      end
    end
  end
end
