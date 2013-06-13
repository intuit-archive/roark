class Stack

  def initialize(args)
    @aws    = args[:aws]
    @name   = args[:name]
    @region = @aws.region
    @logger = Roark.logger
  end

  def create(args)
    @logger.info "Creating Cloud Formation stack '#{@name}' in '#{@region}'."
    create_stack.create :name       => @name,
                        :parameters => args[:parameters],
                        :template   => args[:template]
  end

  def destroy
    @logger.info "Destroying Cloud Formation stack '#{@name}'."
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

  def create_stack
    @create_stack ||= Roark::Aws::CloudFormation::CreateStack.new @aws
  end

  def destroy_stack
    @destroy_stack ||= Roark::Aws::CloudFormation::DestroyStack.new @aws
  end

  def stack_outputs
    @stack_outputs ||= Roark::Aws::CloudFormation::StackOutputs.new @aws
  end

  def stack_status
    @stack_status ||= Roark::Aws::CloudFormation::StackStatus.new @aws
  end
end
