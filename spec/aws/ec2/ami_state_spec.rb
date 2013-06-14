require 'spec_helper'

describe Roark::Aws::Ec2::AmiState do
  it "should return the state of the given ami" do
    image_stub      = stub 'image', :state => :available
    images_stub     = stub :images => { 'ami-12345678' => image_stub }
    connection_stub = stub 'connection', :ec2 => images_stub 
    ami_state = Roark::Aws::Ec2::AmiState.new connection_stub
    expect(ami_state.state('ami-12345678')).to eq(:available)
  end
end
