require 'spec_helper'

describe Roark::Aws::CloudFormation::CreateStack do
  it "should create a stack" do
    pending
    stacks_mock     = mock 'stacks'
    connection_stub = stub 'cf connection', :stacks => stacks_mock
    parameters = [ { :parameter_key => "key", :parameter_value => 'a_val' } ]
    capabilities = ["CAPABILITY_IAM"]
    stacks_mock.should_receive(:create).
                with("test123", "some json",
                     :capabilities => capabilities,
                     :parameters   => parameters)
    @create_stack = Roark::Aws::CloudFormation::CreateStack.new connection_stub
    @create_stack.create :name => 'test123',
                         :template => 'some json',
                         :parameters => { 'key' => 'a_val' }
  end
end
