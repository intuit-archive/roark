module Roark
  module Aws
    module Ec2
      class AmiState
        def initialize(args)
          @image = args[:image]
        end

        def state(ami)
          ec2.images[ami].state
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
