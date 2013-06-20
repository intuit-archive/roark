require 'spec_helper'

describe Roark::Aws::Ec2::AmiTags do

  describe "#add" do
    it "should tag an image with the given hash of tags" do
      Roark.logger stub 'logger stub'
      Roark.logger.stub :info => true, :warn => true
      tags             = { 'name1' => 'val1', 'name2' => 'val2' }
      image_mock       = mock 'image'
      images_stub      = stub :images => { 'ami-12345678' => image_mock }
      connection_stub  = stub 'connection', :ec2 => images_stub
      tags.each_pair do |key, value|
        image_mock.should_receive(:tag).with(key, :value => value)
      end

      @ami_tags = Roark::Aws::Ec2::AmiTags.new connection_stub
      @ami_tags.add :ami_id => 'ami-12345678', :tags => tags
    end
  end

end
