module Roark
  module Aws
    module Ec2
      class AmiState
        def initialize(connection)
          @connection = connection
        end

        def state(image_id)
          @connection.ec2.images[image_id].state
        end
      end
    end
  end
end
