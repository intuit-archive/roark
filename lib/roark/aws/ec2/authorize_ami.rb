module Roark
  module Aws
    module Ec2
      class AuthorizeAmi

        def initialize(connection)
          @connection = connection
        end

        def add(args)
          account_ids = args[:account_ids]
          image_id    = args[:image_id]
          pc = @connection.permission_collection image_id
          pc.add account_ids
        end

      end
    end
  end
end
