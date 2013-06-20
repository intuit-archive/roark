module Roark
  module Aws
    module Ec2
      class AmiTags
        def initialize(connection)
          @connection = connection
          @logger     = Roark.logger
        end

        def add(args)
          ami_id = args[:ami_id]
          tags   = args[:tags]

          tags.each_pair do |key,value|
            @logger.info "Tagging AMI with '#{key}=#{value}'."
            @connection.ec2.images[ami_id].tag key, :value => value
          end
        end
      end
    end
  end
end
