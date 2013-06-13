require 'spec_helper'

describe Roark::ImageCreateWorkflow do
  it "should create and execute a new workflow" do
    logger_stub = stub 'logger'
    Roark.logger logger_stub
    Roark.logger.stub :info => true
    image_mock            = mock 'image mock'
    image_create_workflow = Roark::ImageCreateWorkflow.new image_mock
    args = { :parameters => { 'key' => 'val' },
             :template   => 'template' }
    image_mock.should_receive(:create_instance).with args
    image_mock.should_receive(:wait_for_instance)
    image_mock.should_receive(:stop_instance)
    image_mock.should_receive(:wait_for_instance_to_stop)
    image_mock.should_receive(:create_ami)
    image_mock.should_receive(:wait_for_ami)
    image_mock.should_receive(:destroy_instance)
    image_create_workflow.execute args
  end
end
