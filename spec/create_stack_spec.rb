require 'spec_helper'

describe Roark::Aws::CloudFormation::CreateStack do
  it "should create a stack" do
    stack_mock      = mock 'stack mock'
    cf_stub         = stub 'cf stub', :stacks => stack_mock
    connection_stub = stub 'connection stub', :cf => cf_stub

    parameters = [ { :parameter_key => "key", :parameter_value => 'a_val' } ]
    capabilities = ["CAPABILITY_IAM"]
    stack_mock.should_receive(:create).
               with("test123", "some json",
                    :capabilities => capabilities,
                    :parameters   => parameters)
    create_stack = Roark::Aws::CloudFormation::CreateStack.new connection_stub
    create_stack.create :name       => 'test123',
                        :template   => 'some json',
                        :parameters => { 'key' => 'a_val' }
  end
end
