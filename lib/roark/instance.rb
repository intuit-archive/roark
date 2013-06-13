module Roark
  class Instance

    def initialize(args)
      @aws    = args[:aws]
      @name   = args[:name]
      @logger = Roark.logger
    end

    def create(args)
      parameters = args[:parameters]
      template   = args[:template]

      if exists?
        @logger.error "Stack '#{@name}' already exists."
        return false
      end

      stack.create :name       => @name,
                   :parameters => parameters,
                   :template   => template

      stack.success? ? instance_id : false
    end

    def create_ami_from_instance
      create_ami.create :name        => @name,
                        :instance_id => instance_id
    end

    def destroy
      stack.destroy
    end

    def in_progress?
      stack.in_progress?
    end

    def success?
      stack.success?
    end

    def instance_id
      stack.instance_id
    end

    def exists?
      stack.exists?
    end

    def stop
      manage_instance.stop instance_id
    end

    def status
      instance_status.status instance_id
    end

    private

    def stack
      @stack ||= Stack.new :aws  => @aws,
                           :name => @name,
    end

    def ec2
      @ec2 ||= Roark::Aws::Ec2::Connection.new.connect @aws
    end

    def create_ami
      @create_ami ||= Roark::Aws::Ec2::CreateAmi.new ec2
    end

    def manage_instance
      @manage_instance ||= Roark::Aws::Ec2::ManageInstance.new ec2
    end

    def instance_status
      @instance_status ||= Roark::Aws::Ec2::InstanceStatus.new ec2
    end
  end
end
