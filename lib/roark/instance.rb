module Roark
  class Instance

    def initialize(args)
      @aws_access_key = args[:aws_access_key]
      @aws_secret_key = args[:aws_secret_key]
      @name           = args[:name]
      @region         = args[:region]
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

    def wait_for_instance
      while instance.in_progress?
        sleep 5
      end
      instance.success?
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

    private

    def stack
      @stack ||= Stack.new :aws_access_key => @aws_access_key,
                           :aws_secret_key => @aws_secret_key,
                           :name           => @name,
                           :region         => @region
    end

    def connection
      @connection ||= Roark::Aws::Ec2::Connection.new.connect :aws_access_key => @aws_access_key,
                                                              :aws_secret_key => @aws_secret_key,
                                                              :region         => @region
    end

    def ec2_ami_state
      @ec2_ami_state ||= Roark::Aws::Ec2::AmiState.new connection
    end

    def ec2_destroy_ami
      @ec2_destroy_ami ||= Roark::Aws::Ec2::DestroyAmi.new connection
    end

    def create_ami
      @create_ami ||= Roark::Aws::Ec2::CreateAmi.new connection
    end
  end
end
