require 'spec_helper'

describe Roark::Image do
  before do
    @aws_mock = mock "aws connection mock"
    @aws_mock.stub :region => 'us-west-1'
    init_args = { :aws    => @aws_mock,
                  :region => 'us-west-1' }
    @image = Roark::Image.new init_args
  end

  context "test state" do
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
