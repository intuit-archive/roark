class Stack

  def initialize(args)
    @aws_access_key = args[:aws_access_key]
    @aws_secret_key = args[:aws_secret_key]
    @name           = args[:name]
    @region         = args[:region]
  end

  def create(args)
    create_stack.create args
  end

  def destroy
    destroy_stack.destroy
  end

  def exists?
    stack_status.exists?
  end

  private

  def instance_id
    outputs.select {|o| o.key == 'InstanceId'}.first.value
  end

  def outputs
    stack_outputs.outputs
  end

  def in_progress?
    stack_status =~ /^CREATE_IN_PROGRESS$/
  end

  def success?
    stack_status =~ /^CREATE_COMPLETE$/
  end

  def connection
    @connection ||= CloudFormation::Connection.new(:aws_access_key => @aws_access_key,
                                                   :aws_secret_key => @aws_secret_key,
                                                   :region         => @region
  end

  def create_stack
    @create_stack ||= CloudFormation::CreateStack.new(connection)
  end

  def destroy_stack
    @destroy_stack ||= CloudFormation::DestroyStack.new(connection)
  end

  def stack_outputs
    @stack_outputs ||= CloudFormation::StackOutputs.new(connection)
  end

  def stack_status
    @stack_status ||= CloudFormation::StackStatus.new(connection)
  end
end
