module Roark
  module Aws
    module Ec2
      class CreateAmi

        def initialize(connection)
          @connection = connection
        end

        def create(args)
          instance_id = args[:instance_id]
          name        = args[:name]
          @connection.ec2.images.create :instance_id => instance_id,
                                        :name        => name
        end

      end
    end
  end
end
