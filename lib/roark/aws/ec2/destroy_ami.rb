module Roark
  module Aws
    module Ec2
      class DestroyAmi

        def initialize(connection)
          @connection = connection
          @logger     = Roark.logger
        end

        def destroy(ami)
          image = @connection.ec2.images[ami]

          @block_device_mappings = image.block_device_mappings

          @logger.info "Deleting image '#{ami}'."
          image.delete
          delete_snapshots
        end

        private

        def delete_snapshots
          @block_device_mappings.each_value do |v|
            snapshot_id = v[:snapshot_id]
            @logger.info "Deleting snapshot '#{snapshot_id}'."
            @connection.ec2.snapshots[snapshot_id].delete
          end
        end

        def exists?(ami)
          @connection.ec2.images[ami].exists?
        end
      end
    end
  end
end
