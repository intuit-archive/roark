require 'spec_helper'

describe Roark::AmiCreateWorkflow do
  before do
    logger_stub = stub 'logger'
    @response_stub = mock 'response'
    Roark.logger logger_stub
    Roark.logger.stub :info => true
    @ami_mock            = mock 'ami mock'
    @ami_create_workflow = Roark::AmiCreateWorkflow.new :ami        => @ami_mock,
                                                        :parameters => { 'key' => 'val' },
                                                        :template   => 'template'
  end

  it "should create and execute a new workflow" do
    @response_stub.stub :success? => true
    @ami_mock.should_receive(:create_instance).with(:parameters => { 'key' => 'val' },
                                                    :template   => 'template').and_return @response_stub
    @ami_mock.should_receive(:wait_for_instance).and_return @response_stub
    @ami_mock.should_receive(:stop_instance).and_return @response_stub
    @ami_mock.should_receive(:wait_for_instance_to_stop).and_return @response_stub
    @ami_mock.should_receive(:create_ami).and_return @response_stub
    @ami_mock.should_receive(:wait_for_ami).and_return @response_stub
    @ami_mock.should_receive(:destroy_instance).and_return @response_stub
    @ami_mock.should_receive(:authorize_account_ids).and_return @response_stub
    expect(@ami_create_workflow.execute.success?).to be_true
  end

  it "should raise AmiCreateWorkflowError exception" do
    @response_stub.stub :success? => false, :message => 'error'
    @ami_mock.should_receive(:create_instance).with(:parameters => { 'key' => 'val' },
                                                    :template   => 'template').and_return @response_stub
    expect(@ami_create_workflow.execute.success?).to be_false
  end
end
