require 'spec_helper'

describe Roark::Image do
  let(:init_args) { { :aws_access_key => 'access',
                      :aws_secret_key => 'secret',
                      :name           => 'test-image',
                      :region         => 'us-west-1' } }

  let(:ec2) { mock "ec2 connection" }

  subject { Roark::Image.new init_args }

  describe "#available?" do
    connection_mock = mock "connection mock"
    Roark::Aws::Ec2::Connection.stub :new => connection_mock
    connection_mock.should_receive(:connect).with(init_args)

    Roark::Aws::Ec2::AmiState.should_receive(:new).with ec2

    it "should return true if the image is int state available" do
      expect(subject.available?).to be_true
    end

    it "should return false if the image is not in state available" do
      expect(subject.available?).to be_true
    end
  end

end
