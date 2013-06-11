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

      wait_for_stack_to_complete
    end

    def destroy
      stack.destroy
    end

    private

    def wait_for_stack_to_complete
      while stack.in_progress? || !stack.exists?
        sleep 5
      end
      sleep 5
      stack.success?
    end

    def stack
      @stack ||= Stack.new :aws_access_key => @aws_access_key,
                           :aws_secret_key => @aws_secret_key,
                           :name           => @name,
                           :region         => @region
    end

    def ec2_ami_state
      @ec2_ami_state ||= EC2::AmiState.new :image => self
    end

    def ec2_destroy_ami
      @ec2_destroy_ami ||= EC2::DestroyAmi.new :image => self
    end
  end
end
