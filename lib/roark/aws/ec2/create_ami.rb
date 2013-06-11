module Roark
  module Aws
    module Ec2
      class CreateAmi
        def initialize(args)
          @image       = args[:image]
          @instance_id = args[:instance_id]
        end

        def create
          ec2.images.create :instance_id => @instance_id,
                            :name        => @image.name
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
