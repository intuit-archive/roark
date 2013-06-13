require 'spec_helper'

describe Roark::Instance do
  before do
    @aws_stub = stub 'aws'
    logger_stub = stub 'logger stub', :info => true
    Roark.logger logger_stub
    @instance = Roark::Instance.new :aws  => @aws_stub,
                                    :name => 'test-image'
  end

  %w(destroy exists? in_progress? instance_id success).each do |method|
    describe "##{method}" do
      it "should call stack #{method}" do
        stack_mock = mock 'stack mock'
        stack_mock.should_receive method.to_sym
        Stack.should_receive(:new).
              with(:aws => @aws_stub, :name => 'test-image').
              and_return stack_mock
        @instance.send method.to_sym
      end
    end
  end

  describe "instance management" do
    before do
      @stack_mock = mock 'stack mock'
      @stack_mock.stub :instance_id => 'i-12345678'
      Stack.should_receive(:new).
            with(:aws => @aws_stub, :name => 'test-image').
            and_return @stack_mock
    end

    describe "#create" do
      it "should create an instance" do
        @stack_mock.should_receive(:create).
                    with(:name       => 'test-image',
                         :parameters => 'params',
                         :template   => 'template')
        @instance.create :parameters => 'params',
                         :template   => 'template'
      end
    end

    describe "#create_ami_from_instance" do
      it "should create an ami from instance" do
        create_ami_mock = mock 'create ami mock'
        Roark::Aws::Ec2::CreateAmi.should_receive(:new).
                                   with(@aws_stub).
                                   and_return create_ami_mock
        create_ami_mock.should_receive(:create).
                        with(:name        => 'test-image',
                             :instance_id => 'i-12345678')
        @instance.create_ami_from_instance
      end
    end

    describe "#stop" do
      it "should stop the instance" do
        stop_instance_mock = mock 'stop instance mock'
        Roark::Aws::Ec2::StopInstance.should_receive(:new).
                                      with(@aws_stub).
                                      and_return stop_instance_mock
        stop_instance_mock.should_receive(:stop).with 'i-12345678'
        @instance.stop
      end
    end

    describe "#status" do
      it "should return the status of the instance" do
        instance_status_mock = mock 'instance status mock'
        Roark::Aws::Ec2::InstanceStatus.should_receive(:new).
                                        with(@aws_stub).
                                        and_return instance_status_mock
        instance_status_mock.should_receive(:status).with 'i-12345678'
        @instance.status
      end
    end
  end
end
