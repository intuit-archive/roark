module Roark
  module Aws
    module Ec2
      class AmiAuthorizations

        def initialize(connection)
          @connection = connection
          @logger     = Roark.logger
        end

        def add(args)
          account_ids = args[:account_ids]
          ami_id      = args[:ami_id]

          ami         = @connection.ec2.images[ami_id]

          account_ids.each do |a|
            @logger.info "Authorizing account '#{a}'."
            ami.permissions.add a
          end
        end

      end
    end
  end
end
