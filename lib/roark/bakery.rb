module Roark
  class Bakery

    def initialize(args)
      @aws_access_key = args[:aws_access_key]
      @aws_secret_key = args[:aws_secret_key]
      @name           = args[:name]
      @region         = args[:region]
    end

    def bake(args)
      @stack       = Stack.new :aws_access_key => @aws_access_key,
                               :aws_secret_key => @aws_secret_key,
                               :name           => @name,
                               :region         => @region

      create_stack(args)
      destroy_stack
    end

    def destroy_image
      destroy_stack if stack.exists?
      ec2_destroy_ami.destroy ami
    end

    def create_stack(args)
      template = args[:template]
      @stack.create :template => template
      wait_for_stack_to_complete
    end

    def wait_for_stack_to_complete
      while @stack.in_progress? || !@stack.exists?
        sleep 5
      end
      sleep 5
      @stack.success?
    end

    def create_ami
      #self.ami = stack.create_ami.image_id
      #save
      #wait_for_ami_to_complete
    end

    def wait_for_ami_to_complete
      while pending?
        sleep 5
      end
      available?
    end

    def destroy_stack
      stack.destroy
    end

    def available?
      ami_state == :avaiable
    end

    def pending?
      ami_state == :pending
    end

    private

    def ec2_ami_state
      @ec2_ami_state ||= EC2::AmiState.new :image => self
    end

    def ec2_destroy_ami
      @ec2_destroy_ami ||= EC2::DestroyAmi.new :image => self
    end
  end
end
