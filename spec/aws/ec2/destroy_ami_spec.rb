require 'spec_helper'

describe Roark::Aws::Ec2::DestroyAmi do

  before do 
    Roark.logger stub('logger')
    Roark.logger.stub :info => true, :warn => true
    @image_mock     = mock 'image'
    @snapshot_mock  = mock 'snapshot'
    images_mock     = mock 'images'
    ec2_stub        = stub :images    => { 'ami-12345678' => @image_mock },
                           :snapshots => { 'snap-4417c64c' => @snapshot_mock }
    @mappings = { "/dev/sda1" =>
                  { :snapshot_id           => "snap-4417c64c",
                    :volume_size           => 30,
                    :delete_on_termination => true,
                    :volume_type           => "standard"
                  }
                }
    connection_stub = stub 'connection', :ec2 => ec2_stub
    @destroy_image = Roark::Aws::Ec2::DestroyAmi.new connection_stub
  end
 
  it "should deregister the given ami and destroy it's snapshots " do
    @image_mock.stub :exists? => true
    @image_mock.stub :block_device_mappings => @mappings
    @image_mock.should_receive :delete
    @snapshot_mock.should_receive :delete
    @destroy_image.destroy 'ami-12345678'
  end

end
