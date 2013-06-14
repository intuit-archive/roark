module Roark
  module Aws
    module Ec2
      class DestroyAmi

        def initialize(connection)
          @connection = connection
          @logger     = Roark.logger
        end

        def destroy(ami_id)
          ami = @connection.ec2.images[ami_id]

          @block_device_mappings = ami.block_device_mappings

          @logger.info "Deleting AMI '#{ami_id}'."
          ami.delete
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

      end
    end
  end
end
