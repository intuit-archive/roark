module Roark
  module Aws
    module CloudFormation
      class StackOutputs
        def initialize(stack)
          @stack = stack
        end

        def outputs
          connect.stacks[@stack.name].outputs
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
