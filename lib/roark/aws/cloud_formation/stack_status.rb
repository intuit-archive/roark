module Roark
  module Aws
    module CloudFormation
      class StackStatus

        def initialize(connection)
          @connection = connection
        end

        def status(name)
          @connection.stacks[name].status
        end

        def exists?(name)
          @connection.stacks[name].exists?
        end

      end
    end
  end
end
