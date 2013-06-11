module Roark
  module Aws
    module CloudFormation
      class CreateStack
        def initialize(stack)
          @stack = stack
        end

        def create
          connect.stacks.create @stack.name, template_body, { :capabilities => capabilities,
                                                              :parameters   => @stack.parameters }
        end

        private

        def capabilities
          ['CAPABILITY_IAM']
        end

        def template_body
          File.read(File.join(Rails.root, "lib/cloud_formation_templates/image.json"))
        end

        def connect
          @connect ||= CloudFormation::Connect.new(:account => @stack.account,
                                                   :region  => @stack.region.name).connect
        end

      end
    end
  end
end
