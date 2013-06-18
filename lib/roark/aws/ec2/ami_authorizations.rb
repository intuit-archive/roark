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
          account_ids.each {|a| @logger.info "Authorizing account '#{a}.'"}
          @connection.permission_collection(ami_id).add account_ids
        end

      end
    end
  end
end
