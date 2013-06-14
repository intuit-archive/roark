require 'spec_helper'

describe Roark::Aws::CloudFormation::CreateStack do
  describe "#create" do
    it "should create the requestd stack" do
      stacks_mock     = mock 'stacks'
      cf_stub         = stub 'cf', :stacks => stacks_mock
      connection_stub = stub 'connection', :cf => cf_stub
      create_stack = Roark::Aws::CloudFormation::CreateStack.new connection_stub
      stacks_mock.should_receive(:create).
                  with("test123", "{\"some\":\"json\"}",
                       { :capabilities => ["CAPABILITY_IAM"],
                         :parameters   => [{ :parameter_key   => "key",
                                             :parameter_value => "val"}]})
      create_stack.create :name       => 'test123',
                          :parameters => { 'key' => 'val' },
                          :template   => "{\"some\":\"json\"}"
    end
  end
end
