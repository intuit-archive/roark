require 'spec_helper'

describe Roark::Aws::Ec2::AmiAuthorizations do

  describe "#add" do
    it "should authorize an array of account ids to an ami" do
      Roark.logger stub 'logger stub'
      Roark.logger.stub :info => true, :warn => true
      permissions_mock = mock 'permissions'
      image_stub      = stub 'image', :permissions => permissions_mock
      images_stub     = stub :images => { 'ami-12345678' => image_stub }
      connection_stub = stub 'connection', :ec2 => images_stub
      permissions_mock.should_receive(:add).with('1234-5678-9012')
      permissions_mock.should_receive(:add).with('1234-5678-9013')
      @authorize_ami = Roark::Aws::Ec2::AmiAuthorizations.new connection_stub
      @authorize_ami.add :ami_id      => 'ami-12345678',
                         :account_ids => ['1234-5678-9012', '1234-5678-9013']
    end
  end

end
