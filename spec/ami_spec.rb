require 'spec_helper'

describe Roark::Ami do
  before do
    logger_stub = stub 'logger stub'
    Roark.logger.stub :info => true

    @aws_mock = mock "aws connection mock"
    @aws_mock.stub :region => 'us-west-1'
    init_args = { :aws    => @aws_mock,
                  :name   => 'test-ami' }

    @ami = Roark::Ami.new init_args
  end

  context "testing instance methods" do
    before do
      @instance_mock = mock 'instance mock'
      Roark::Instance.should_receive(:new).
                      with(:aws  => @aws_mock,
                           :name => 'test-ami').
                      and_return @instance_mock
      @instance_mock.stub :instance_id => 'i-1234abcd'
    end

    describe "#create_instance" do
      it "should create on instance" do
        args = { :parameters => 'parameters',
                 :template   => 'template' }
        @instance_mock.should_receive(:create).with args
        expect(@ami.create_instance(args).success?).to be_true
      end

      it "should return unsuccesful if an AWS exception is raised" do
        args = { :parameters => 'parameters',
                 :template   => 'template' }
        @instance_mock.should_receive(:create).and_raise AWS::Errors::Base.new "error"
        expect(@ami.create_instance(args).success?).to be_false
      end
    end

    describe "#create_ami" do
      it "should call create_ami_from_instance on instance and return ami" do
        ami_mock = mock 'ami'
        @instance_mock.stub :create_ami_from_instance => ami_mock
        ami_mock.stub :ami_id => 'ami-12345678'
        expect(@ami.create_ami.success?).to be_true
        expect(@ami.ami_id).to eq('ami-12345678')
      end

      it "should return unsuccesful if an AWS exception is raised" do
        ami_mock = mock 'ami'
        @instance_mock.should_receive(:create_ami_from_instance).
                       and_raise AWS::Errors::Base.new "error"
        expect(@ami.create_ami.success?).to be_false
      end
    end

    describe "#stop_instance" do
      it "should call stop on instance" do
        @instance_mock.should_receive(:stop)
        expect(@ami.stop_instance.success?).to be_true
      end

      it "should return unsuccesful if an AWS exception is raised" do
        @instance_mock.should_receive(:stop).
                       and_raise AWS::Errors::Base.new "error"
        expect(@ami.stop_instance.success?).to be_false
      end
    end

    describe "#destroy_instance" do
      it "should call destroy on instance" do
        @instance_mock.should_receive(:destroy)
        expect(@ami.destroy_instance.success?).to be_true
      end

      it "should return unsuccesful if an AWS exception is raised" do
        @instance_mock.should_receive(:destroy).
                       and_raise AWS::Errors::Base.new "error"
        expect(@ami.destroy_instance.success?).to be_false
      end
    end

    describe "#wait_for_instance_to_stop" do
      it "should sleep until instance is stopped" do
        @instance_mock.stub(:status).and_return(:available, :stopped)
        @ami.should_receive(:sleep).with(15)
        expect(@ami.wait_for_instance_to_stop.success?).to be_true
      end
    end

    describe "#wait_for_instance" do
      it "should sleep until the instance is not in state in_progress" do
        @instance_mock.stub(:in_progress?).and_return(true, false)
        @instance_mock.stub :exists? => true
        @ami.should_receive(:sleep).with(60)
        @instance_mock.stub :success? => true
        expect(@ami.wait_for_instance.success?).to be_true
      end
    end

    describe "#wait_for_instance" do
      it "should sleep until the instance exists" do
        @instance_mock.stub :in_progress? => false
        @instance_mock.stub(:exists?).and_return(false, true)
        @ami.should_receive(:sleep).with(60)
        @instance_mock.stub :success? => true
        expect(@ami.wait_for_instance.success?).to be_true
      end
    end

    describe "#wait_for_instance" do
      it "should return false if instance create was not succesful" do
        @instance_mock.stub :in_progress? => false
        @instance_mock.stub :exists? => true
        @instance_mock.stub :success? => false
        expect(@ami.wait_for_instance.success?).to be_false
      end
    end

    describe "#instance_id" do
      it "should call instance_id on instance" do
        @instance_mock.stub :instance_id => 'i-12345678'
        expect(@ami.instance_id).to eq('i-12345678')
      end
    end
  end

  context "testing state methods" do
    before do
      @ec2_ami_state_mock = mock 'ec2 ami state'
      Roark::Aws::Ec2::AmiState.should_receive(:new).
                                with(@aws_mock).
                                and_return @ec2_ami_state_mock
    end

    describe "#available?" do
      it "should return true if the ami is in state available" do
        @ec2_ami_state_mock.stub :state => :available
        expect(@ami.available?).to be_true
      end

      it "should return false if the ami is not in state available" do
        @ec2_ami_state_mock.stub :state => :pending
        expect(@ami.available?).to be_false
      end
    end

    describe "#pending?" do
      it "should return true if the ami is in state pending" do
        @ec2_ami_state_mock.stub :state => :pending
        expect(@ami.pending?).to be_true
      end

      it "should return false if the ami is not in state pending" do
        @ec2_ami_state_mock.stub :state => :stopped
        expect(@ami.pending?).to be_false
      end
    end

    describe "#exists?" do
      it "should return true if the ami exists" do
        @ec2_ami_state_mock.stub :exists? => true
        expect(@ami.exists?).to be_true
      end

      it "should return false if the ami does not exist" do
        @ec2_ami_state_mock.stub :exists? => false
        expect(@ami.exists?).to be_false
      end
    end

    describe "#state" do
      it "should call Ec2::AmiState for ami state" do
        @ec2_ami_state_mock.stub :state => :available
        expect(@ami.state).to eq(:available)
      end
    end

    describe "#wait_for_ami" do
      it "should wait for the ami to not be in state pending" do
        @ec2_ami_state_mock.stub(:state).and_return(:pending, :available)
        @ec2_ami_state_mock.stub :exists? => true
        @ami.should_receive(:sleep).with(15)
        expect(@ami.wait_for_ami.success?).to be_true
      end

      it "should wait for the ami if it does not yet exists" do
        @ec2_ami_state_mock.stub(:exists?).and_return(false, true)
        @ec2_ami_state_mock.stub :state => :available
        @ami.should_receive(:sleep).with(15)
        expect(@ami.wait_for_ami.success?).to be_true
      end

      it "should return false if the ami is not in state available" do
        @ec2_ami_state_mock.stub :state => :failed, :exists? => true
        expect(@ami.wait_for_ami.success?).to be_false
      end
    end
  end

  context "testing ami methods" do
    describe "#destroy" do
      it "should call destroy on Ec2::DestroyAmi" do
        @ami.ami_id = 'ami-12345678'
        ec2_destroy_ami_mock = mock 'aws_destroy_ami'
        Roark::Aws::Ec2::DestroyAmi.should_receive(:new).
                                    with(@aws_mock).
                                    and_return ec2_destroy_ami_mock
        ec2_destroy_ami_mock.should_receive(:destroy).with('ami-12345678')
        expect(@ami.destroy.success?).to be_true
      end
    end
  end

end
