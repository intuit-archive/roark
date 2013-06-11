class Stack

  def initialize(args)
    @aws_access_key = args[:aws_access_key]
    @aws_secret_key = args[:aws_secret_key]
    @name           = args[:name]
    @region         = args[:region]
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
    status.exists?
  end

  def in_progress?
    status =~ /^CREATE_IN_PROGRESS$/
  end

  def success?
    status =~ /^CREATE_COMPLETE$/
  end

  def status
    stack_status.status @name
  end

  def instance_id
    outputs.select {|o| o.key == 'InstanceId'}.first.value
  end

  private

  def outputs
    stack_outputs.outputs @name
  end

  def connection
    @connection ||= Roark::Aws::CloudFormation::Connection.new.connect :aws_access_key => @aws_access_key,
                                                                       :aws_secret_key => @aws_secret_key,
                                                                       :region         => @region
  end

  def create_stack
    @create_stack ||= Roark::Aws::CloudFormation::CreateStack.new(connection)
  end

  def destroy_stack
    @destroy_stack ||= Roark::Aws::CloudFormation::DestroyStack.new(connection)
  end

  def stack_outputs
    @stack_outputs ||= Roark::Aws::CloudFormation::StackOutputs.new(connection)
  end

  def stack_status
    @stack_status ||= Roark::Aws::CloudFormation::StackStatus.new(connection)
  end
end
