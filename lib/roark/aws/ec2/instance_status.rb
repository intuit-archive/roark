module Roark
  module Aws
    module Ec2
      class InstanceStatus
        def initialize(connection)
          @connection = connection
        end

        def status(id)
          @connection.instances[id].status
        end
      end
    end
  end
end
