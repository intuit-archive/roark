require 'spec_helper'

describe Roark::Image do
  before do
    logger_stub = stub 'logger stub'
    Roark.logger.stub :info => true

    @aws_mock = mock "aws connection mock"
    @aws_mock.stub :region => 'us-west-1'
    init_args = { :aws    => @aws_mock,
                  :name   => 'test-image' }

    @image = Roark::Image.new init_args
  end

  context "testing instance methods" do
    before do
      @instance_mock = mock 'instance mock'
      Roark::Instance.should_receive(:new).
                      with(:aws  => @aws_mock,
                           :name => 'test-image').
                      and_return @instance_mock
      @instance_mock.stub :instance_id => 'i-1234abcd'
    end

    describe "#create_instance" do
      it "should create on instance" do
        args = { :parameters => 'parameters',
                 :template   => 'template' }
        @instance_mock.should_receive(:create).with args
        expect(@image.create_instance(args).success?).to be_true
      end
    end

    describe "#create_ami" do
      it "should call create_ami_from_instance on instance and return image" do
        image_mock = mock 'image'
        @instance_mock.stub :create_ami_from_instance => image_mock
        image_mock.stub :image_id => 'ami-12345678'
        expect(@image.create_ami.success?).to be_true
        expect(@image.image_id).to eq('ami-12345678')
      end
    end

    describe "#stop_instance" do
      it "should call stop on instance" do
        @instance_mock.should_receive(:stop)
        expect(@image.stop_instance.success?).to be_true
      end
    end

    describe "#destroy_instance" do
      it "should call destroy on instance" do
        @instance_mock.should_receive(:destroy)
        expect(@image.destroy_instance.success?).to be_true
      end
    end

    describe "#wait_for_instance_to_stop" do
      it "should sleep until instance is stopped" do
        @instance_mock.stub(:status).and_return(:available, :stopped)
        @image.should_receive(:sleep).with(15)
        @image.wait_for_instance_to_stop
      end
    end

    describe "#wait_for_instance" do
      it "should sleep until the instance is not in state in_progress" do
        @instance_mock.stub(:in_progress?).and_return(true, false)
        @instance_mock.stub :exists? => true
        @image.should_receive(:sleep).with(15)
        @instance_mock.stub :success? => true
        expect(@image.wait_for_instance).to be_true
      end
    end

    describe "#wait_for_instance" do
      it "should sleep until the instance exists" do
        @instance_mock.stub :in_progress? => false
        @instance_mock.stub(:exists?).and_return(false, true)
        @image.should_receive(:sleep).with(15)
        @instance_mock.stub :success? => true
        expect(@image.wait_for_instance).to be_true
      end
    end

    describe "#wait_for_instance" do
      it "should return false if instance create was not succesful" do
        @instance_mock.stub :in_progress? => false
        @instance_mock.stub :exists? => true
        @instance_mock.stub :success? => false
        expect(@image.wait_for_instance).to be_false
      end
    end

    describe "#instance_id" do
      it "should call instance_id on instance" do
        @instance_mock.stub :instance_id => 'i-12345678'
        expect(@image.instance_id).to eq('i-12345678')
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
      it "should return true if the image is in state available" do
        @ec2_ami_state_mock.stub :state => :available
        expect(@image.available?).to be_true
      end

      it "should return false if the image is not in state available" do
        @ec2_ami_state_mock.stub :state => :pending
        expect(@image.available?).to be_false
      end
    end

    describe "#pending?" do
      it "should return true if the image is in state pending" do
        @ec2_ami_state_mock.stub :state => :pending
        expect(@image.pending?).to be_true
      end

      it "should return false if the image is not in state pending" do
        @ec2_ami_state_mock.stub :state => :stopped
        expect(@image.pending?).to be_false
      end
    end

    describe "#state" do
      it "should call Ec2::AmiState for image state" do
        @ec2_ami_state_mock.stub :state => :available
        expect(@image.state).to eq(:available)
      end
    end

    describe "#wait_for_ami" do
      it "should wait for the ami to not be in state pending" do
        @ec2_ami_state_mock.stub(:state).and_return(:pending, :available)
        @image.should_receive(:sleep).with(15)
        expect(@image.wait_for_ami).to be_true

      end

      it "should return false if the ami is not in state available" do
        @ec2_ami_state_mock.stub :state => :failed
        expect(@image.wait_for_ami).to be_false
      end
    end
  end

  context "testing image methods" do
    describe "#destroy" do
      it "should call destroy on Ec2::DestroyAmi" do
        @image.image_id = 'ami-12345678'
        ec2_destroy_ami_mock = mock 'aws_destroy_ami'
        Roark::Aws::Ec2::DestroyAmi.should_receive(:new).
                                    with(@aws_mock).
                                    and_return ec2_destroy_ami_mock
        ec2_destroy_ami_mock.should_receive(:destroy).with('ami-12345678')
        expect(@image.destroy.success?).to be_true
      end
    end
  end

end
