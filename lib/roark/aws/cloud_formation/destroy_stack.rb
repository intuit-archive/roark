module Roark
  module Aws
    module CloudFormation
      class DestroyStack

        def initialize(connection)
          @connection = connection
        end

        def destroy(args)
          name = args[:name]
          @connection.stacks[name].delete
        end

      end
    end
  end
end
