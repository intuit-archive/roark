module Roark
  module Aws
    module Ec2
      class AmiState
        def initialize(connection)
          @connection = connection
        end

        def state(ami_id)
          @connection.ec2.images[ami_id].state
        end

        def exists?(ami_id)
          @connection.ec2.images[ami_id].exists?
        end
      end
    end
  end
end
