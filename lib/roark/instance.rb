module Roark
  class Instance

    extend Forwardable

    def_delegators :stack, :destroy, :exists?, :in_progress?, :instance_id, :success

    def initialize(args)
      @aws    = args[:aws]
      @name   = args[:name]
      @logger = Roark.logger
    end

    def create(args)
      parameters = args[:parameters]
      template   = args[:template]

      stack.create :name       => @name,
                   :parameters => parameters,
                   :template   => template
    end

    def create_ami_from_instance
      create_ami.create :name        => @name,
                        :instance_id => instance_id
    end

    def stop
      stop_instance.stop instance_id
    end

    def status
      instance_status.status instance_id
    end

    private

    def stack
      @stack ||= Stack.new :aws  => @aws, :name => @name
    end

    def create_ami
      @create_ami ||= Roark::Aws::Ec2::CreateAmi.new @aws
    end

    def stop_instance
      @stop_instance ||= Roark::Aws::Ec2::StopInstance.new @aws
    end

    def instance_status
      @instance_status ||= Roark::Aws::Ec2::InstanceStatus.new @aws
    end
  end
end
