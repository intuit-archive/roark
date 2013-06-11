module Roark
  module Aws
    module Ec2
      class DestroyAmi

        include Ec2::Shared

        def destroy(ami)
          return true unless exists? ami

          image = connect.images[ami]

          block_device_mappings = image.block_device_mappings

          image.delete if image.state == :available

          block_device_mappings.each_value do |v|
            connect.snapshots[v[:snapshot_id]].delete
          end
        end

        def exists?(ami)
          connect.images[ami].exists?
        end
      end
    end
  end
end
