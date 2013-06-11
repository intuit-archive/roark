module Roark
  module Aws
    module Ec2
      class CreateAmi

        include Ec2::Shared

        def initialize(args)
          @aws_access_key = args[:aws_access_key]
          @aws_secret_key = args[:aws_secret_key]
          @region         = args[:region]
        end

        def create(args)
          instance_id = args[:instance_id]
          name        = args[:name]
          connect.images.create :instance_id => instance_id,
                                :name        => name
        end

      end
    end
  end
end
