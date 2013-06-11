module Roark
  module Aws
    module CloudFormation
      class StackStatus

        def initialize(connection)
          @connection = connection
        end

        def status(args)
          name = args[:name]
          @connection.stacks[name].status
        end

        def exists?(args)
          name = args[:name]
          @connection.stacks[name].exists?
        end

      end
    end
  end
end
