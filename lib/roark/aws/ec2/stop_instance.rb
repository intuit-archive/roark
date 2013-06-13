module Roark
  module Aws
    module Ec2
      class StopInstance
        def initialize(connection)
          @connection = connection
        end

        def stop(id)
          @connection.ec2.instances[id].stop
        end
      end
    end
  end
end
