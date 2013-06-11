module Roark
  module Aws
    module Ec2
      class AmiState
        def initialize(connection)
          @connection = connection
        end

        def state(ami)
          @connection.images[ami].state
        end
      end
    end
  end
end
