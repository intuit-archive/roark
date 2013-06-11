module Roark
  module Aws
    module Ec2
      class DestroyAmi

        def initialize(connection)
          @connection = connection
        end

        def destroy(ami)
          return true unless exists? ami

          image = @connection.images[ami]

          block_device_mappings = image.block_device_mappings

          image.delete if image.state == :available

          block_device_mappings.each_value do |v|
            @connection.snapshots[v[:snapshot_id]].delete
          end
        end

        def exists?(ami)
          @connection.images[ami].exists?
        end
      end
    end
  end
end
