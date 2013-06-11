module Roark
  module Aws
    module CloudFormation
      class CreateStack

        def initialize(connection)
          @connection = connection
        end

        def create(args)
          name       = args[:name]
          parameters = args[:parameters]
          template   = args[:template]
          @connection.stacks.create name, template, { :capabilities => capabilities,
                                                      :parameters   => format_parameters(parameters) }
        end

        private

        def format_parameters(parameters)
          parameters.map do |p|
            { :parameter_key   => p,
              :parameter_value => p }
          end
        end

        def capabilities
          ['CAPABILITY_IAM']
        end

      end
    end
  end
end
