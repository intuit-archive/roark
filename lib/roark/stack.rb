class Stack

  def initialize(args)
    @aws_access_key = args[:aws_access_key]
    @aws_secret_key = args[:aws_secret_key]
    @name           = args[:name]
    @region         = args[:region]
    @logger         = Roark.logger
  end

  def create(args)
    create_stack.create :name       => @name,
                        :parameters => args[:parameters],
                        :template   => args[:template]
  end

  def destroy
    destroy_stack.destroy @name
  end

  def exists?
    stack_status.exists? @name
  end

  def in_progress?
    status =~ /^CREATE_IN_PROGRESS$/
  end

  def success?
    status =~ /^CREATE_COMPLETE$/
  end

  def instance_id
    id = outputs.select {|o| o.key == 'InstanceId'}.first
    id ? id.value : "unknown"
  end

  private

  def status
    stack_status.status @name
  end

  def outputs
    stack_outputs.outputs @name
  end

  def cf
    @cf ||= Roark::Aws::CloudFormation::Connection.new.connect :aws_access_key => @aws_access_key,
                                                               :aws_secret_key => @aws_secret_key,
                                                               :region         => @region
  end

  def create_stack
    @create_stack ||= Roark::Aws::CloudFormation::CreateStack.new cf
  end

  def destroy_stack
    @destroy_stack ||= Roark::Aws::CloudFormation::DestroyStack.new cf
  end

  def stack_outputs
    @stack_outputs ||= Roark::Aws::CloudFormation::StackOutputs.new cf
  end

  def stack_status
    @stack_status ||= Roark::Aws::CloudFormation::StackStatus.new cf 
  end
end
