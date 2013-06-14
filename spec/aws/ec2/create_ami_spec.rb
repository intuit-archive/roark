require 'spec_helper'

describe Roark::Aws::Ec2::CreateAmi do
  it "should return the state of the given ami" do
    image_stub      = stub 'image', :state => :available
    images_mock     = mock 'images'
    ec2_stub        = stub :images => images_mock
    connection_stub = stub 'connection', :ec2 => ec2_stub
    images_mock.should_receive(:create).
                with(:instance_id => 'i-12345678',
                     :name        => 'test123').
                and_return 'an_image'
    create_ami = Roark::Aws::Ec2::CreateAmi.new connection_stub
    expect(create_ami.create(:instance_id => 'i-12345678',
                             :name        => 'test123')).to eq('an_image')
  end
end
