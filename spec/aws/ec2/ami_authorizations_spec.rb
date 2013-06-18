require 'spec_helper'

describe Roark::Aws::Ec2::AmiAuthorizations do

  describe "#add" do
    it "should authorize an array of account ids to an ami" do
      Roark.logger stub 'logger stub'
      Roark.logger.stub :info => true, :warn => true
      account_ids      = ['123456789012', '123456789013']
      permissions_mock = mock 'permissions'
      image_stub       = stub 'image', :permissions => permissions_mock
      images_stub      = stub :images => { 'ami-12345678' => image_stub }
      connection_stub  = stub 'connection', :ec2 => images_stub
      account_ids.each { |account_id| permissions_mock.should_receive(:add).with(account_id) }
      @authorize_ami = Roark::Aws::Ec2::AmiAuthorizations.new connection_stub
      @authorize_ami.add :ami_id      => 'ami-12345678',
                         :account_ids => account_ids
    end
  end

end
