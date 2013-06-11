module Roark
  module Aws
    module CloudFormation
      class DestroyStack
        def initialize(stack)
          @stack = stack
        end

        def destroy
          connect.stacks[@stack.name].delete
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
