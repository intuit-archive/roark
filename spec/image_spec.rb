require 'spec_helper'

describe Roark::Image do
  before do
    logger_stub = stub 'logger', :info => true
    Roark.logger logger_stub

    @aws_mock = mock "aws connection mock"
    @aws_mock.stub :region => 'us-west-1'
    init_args = { :aws    => @aws_mock,
                  :name   => 'test-image' }

    @image = Roark::Image.new init_args
  end

  context "testing instance" do
    before do
      @instance_mock = mock 'instance mock'
      Roark::Instance.should_receive(:new).
                      with(:aws  => @aws_mock,
                           :name => 'test-image').
                      and_return @instance_mock
      @instance_mock.stub :instance_id => 'i-1234abcd'
    end

    it "#create_instance" do
      args = { :parameters => 'parameters',
               :template   => 'template' }
      @instance_mock.should_receive(:create).with args
      @image.create_instance args
    end

    it "#create_ami" do
      image_mock = mock 'image'
      @instance_mock.stub :create_ami_from_instance => image_mock
      image_mock.stub :image_id => 'ami-12345678'
      @image.create_ami
      expect(@image.image_id).to eq('ami-12345678')
    end

    it "#destroy_instance" do
      @instance_mock.should_receive(:destroy)
      @image.destroy_instance
    end

    it "#wait_for_instance_to_stop" do
      @instance_mock.stub(:status).and_return(:available, :stopped)
      @image.should_receive(:sleep).with(15)
      @image.wait_for_instance_to_stop
    end
  end

  context "testing state" do
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

  end

end
