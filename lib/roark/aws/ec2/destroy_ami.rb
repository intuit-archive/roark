module Roark
  module Aws
    module Ec2
      class DestroyAmi
        def initialize(args)
          @image = args[:image]
        end

        def destroy(ami)
          return true unless exists? ami

          image = ec2.images[ami]

          block_device_mappings = image.block_device_mappings

          image.delete if image.state == :available

          block_device_mappings.each_value do |v|
            ec2.snapshots[v[:snapshot_id]].delete
          end
        end

        def exists?(ami)
          ec2.images[ami].exists?
        end

        private

        def ec2
          @ec2 ||= EC2::Connect.new(:account => @image.account,
                                    :region  => @image.region.name).connect
        end

      end
    end
  end
end
