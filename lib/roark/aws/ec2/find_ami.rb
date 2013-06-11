module Roark
  module Aws
    module Ec2
      class FindAmi
        def initialize(connection)
          @connection = connection
        end

        def find(name)
          @connection.images.select { |i| i.name == name }.first
        end
      end
    end
  end
end
