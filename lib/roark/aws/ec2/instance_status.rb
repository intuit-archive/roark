module Roark
  module Aws
    module Ec2
      class InstanceStatus
        def initialize(connection)
          @connection = connection
        end

        def state(id)
          @connection.instances[id].state
        end
      end
    end
  end
end
