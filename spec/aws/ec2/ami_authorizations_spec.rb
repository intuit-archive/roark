require 'spec_helper'

describe Roark::Aws::Ec2::AmiAuthorizations do

  describe "#add" do
    before do
      Roark.logger stub 'logger stub'
      Roark.logger.stub :info => true, :warn => true
      @connection_mock = mock 'connection'
      @authorize_ami = Roark::Aws::Ec2::AmiAuthorizations.new @connection_mock
    end

    it "should authorize an arrary of account ids to an ami" do
      pc_mock = mock 'permission_collection'
      @connection_mock.should_receive(:permission_collection).
                       with('ami-12345678').
                       and_return pc_mock
      pc_mock.should_receive(:add).with(['1234-5678-9012', '1234-5678-9013'])
      @authorize_ami.add :ami_id      => 'ami-12345678',
                         :account_ids => ['1234-5678-9012', '1234-5678-9013']
    end
  end
end
