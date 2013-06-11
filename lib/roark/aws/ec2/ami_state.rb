module Roark
  module Aws
    module Ec2
      class AmiState

        include Ec2::Shared

        def initialize(args)
          @aws_access_key = args[:aws_access_key]
          @aws_secret_key = args[:aws_secret_key]
          @region         = args[:region]
        end

        def state(ami)
          connect.images[ami].state
        end
      end
    end
  end
end
