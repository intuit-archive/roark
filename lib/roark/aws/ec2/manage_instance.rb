module Roark
  module Aws
    module Ec2
      class ManageInstance
        def initialize(connection)
          @connection = connection
        end

        def stop(id)
          @connection.instances[id].stop
        end
      end
    end
  end
end
