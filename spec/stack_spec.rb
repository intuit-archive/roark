require 'spec_helper'

describe Stack do
  before do
    logger_stub = stub 'logger stub'
    Roark.logger logger_stub
    Roark.logger.stub :info => true
    @aws_stub = stub 'aws', :region => 'us-west-1'
    @stack = Stack.new :aws  => @aws_stub,
                       :name => 'test-image'
  end

  describe "#create" do
    it "should call create stack" do
      create_stack_mock = mock 'create stack'
      Roark::Aws::CloudFormation::CreateStack.should_receive(:new).
                                              with(@aws_stub).
                                              and_return create_stack_mock
      create_stack_mock.should_receive(:create).
                        with(:name       => 'test-image',
                             :parameters => 'params',
                             :template   => 'template')
      @stack.create :parameters => 'params',
                    :template   => 'template'
    end
  end

  describe "#destroy" do
    it "should call destroy stack" do
      destroy_stack_mock = mock 'destroy stack'
      Roark::Aws::CloudFormation::DestroyStack.should_receive(:new).
                                               with(@aws_stub).
                                               and_return destroy_stack_mock
      destroy_stack_mock.should_receive(:destroy).with('test-image')
      @stack.destroy
    end
  end

  context "status" do
    before do 
      @stack_status_mock = mock 'status'
      Roark::Aws::CloudFormation::StackStatus.should_receive(:new).
                                              with(@aws_stub).
                                              and_return @stack_status_mock
    end

    describe "#exists?" do
      it "should return true if stack exists" do
        @stack_status_mock.stub :exists? => true
        expect(@stack.exists?).to be_true
      end
      it "should return false if stack does not exists" do
        @stack_status_mock.stub :exists? => false
        expect(@stack.exists?).to be_false
      end
    end

    describe "#success?" do
      it "should return true if stack status is CREATE_COMPLETE" do
        @stack_status_mock.stub :status => 'CREATE_COMPLETE'
        expect(@stack.success?).to be_true
      end
      it "should return false if stack status is not CREATE_COMPLETE" do
        @stack_status_mock.stub :status => 'CREATE_IN_PROGRESS'
        expect(@stack.success?).to be_false
      end
    end

    describe "#in_progress?" do
      it "should return true if stack status is CREATE_IN_PROGRESS" do
        @stack_status_mock.stub :status => 'CREATE_IN_PROGRESS'
        expect(@stack.in_progress?).to be_true
      end
      it "should return false if stack status is not CREATE_IN_PROGRESS" do
        @stack_status_mock.stub :status => 'CREATE_COMPLETE'
        expect(@stack.in_progress?).to be_false
      end
    end

  end

  describe "#instance_id" do
    before do
      @stack_output_mock  = mock 'stack output'
      @stack_outputs_mock = mock 'stack output mock'
      Roark::Aws::CloudFormation::StackOutputs.should_receive(:new).
                                               with(@aws_stub).
                                               and_return @stack_outputs_mock
    end

    it "should return the instance_id from the stack output" do
      @stack_outputs_mock.stub :outputs => [ @stack_output_mock ]
      @stack_output_mock.stub :key => 'InstanceId', :value => 'i-12345678'
      expect(@stack.instance_id).to eq('i-12345678')
    end

  end

end
