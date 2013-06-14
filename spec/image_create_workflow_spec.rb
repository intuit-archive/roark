require 'spec_helper'

describe Roark::ImageCreateWorkflow do
  before do
    logger_stub = stub 'logger'
    @response_stub = mock 'response'
    Roark.logger logger_stub
    Roark.logger.stub :info => true
    @image_mock            = mock 'image mock'
    @image_create_workflow = Roark::ImageCreateWorkflow.new :image      => @image_mock,
                                                            :parameters => { 'key' => 'val' },
                                                            :template   => 'template'
  end

  it "should create and execute a new workflow" do
    @response_stub.stub :success? => true
    @image_mock.should_receive(:create_instance).with(:parameters => { 'key' => 'val' },
                                                      :template   => 'template').and_return @response_stub
    @image_mock.should_receive(:wait_for_instance).and_return @response_stub
    @image_mock.should_receive(:stop_instance).and_return @response_stub
    @image_mock.should_receive(:wait_for_instance_to_stop).and_return @response_stub
    @image_mock.should_receive(:create_ami).and_return @response_stub
    @image_mock.should_receive(:wait_for_ami).and_return @response_stub
    @image_mock.should_receive(:destroy_instance).and_return @response_stub
    @image_create_workflow.execute
  end

  it "should raise ImageCreateWorkflowError exception" do
    @response_stub.stub :success? => false, :message => 'error'
    @image_mock.should_receive(:create_instance).with(:parameters => { 'key' => 'val' },
                                                      :template   => 'template').and_return @response_stub
    expect(@image_create_workflow.execute.success?).to be_false
  end
end
