require 'spec_helper'

describe Roark::Aws::Connection do
  before do
    @args       = { :access_key_id     => 'abc',
                    :secret_access_key => '123',
                    :region            => 'us-west-1' }
    @connection = Roark::Aws::Connection.new @args
  end

  describe "#cf" do
    it "should create and AWS::CloudFormation connection" do
      cf_mock = mock 'cf'
      AWS::CloudFormation.should_receive(:new).with(@args).and_return cf_mock
      expect(@connection.cf).to eq(cf_mock)
    end
  end

  describe "#ec2" do
    it "should create and AWS::EC2 connection" do
      ec2_mock = mock 'ec2'
      AWS::EC2.should_receive(:new).with(@args).and_return ec2_mock
      expect(@connection.ec2).to eq(ec2_mock)
    end
  end

end
