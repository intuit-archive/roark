module Roark
  module Aws
    module CloudFormation
      class StackStatus
        def initialize(stack)
          @stack = stack
        end

        def status
          connect.stacks[@stack.name].status
        end

        def exists?
          connect.stacks[@stack.name].exists?
        end

        private

        def connect
          @connect ||= CloudFormation::Connect.new(:account => @stack.account,
                                                   :region  => @stack.region.name).connect
        end

      end
    end
  end
end
