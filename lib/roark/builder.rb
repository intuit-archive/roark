require 'workflow'

module Roark
  class Builder

    attr_accessor :ami, :instance, :name, :reigon, :source_ami, :workflow_state

    include Workflow

    workflow do
      state :new do
        event :create_stack, :transitions_to => :stack_created
        event :destroy_image, :transitions_to => :failed
      end
      state :stack_created do
        event :create_ami, :transitions_to => :ami_created
        event :destroy_image, :transitions_to => :failed
      end
      state :ami_created do
        event :destroy_stack, :transitions_to => :ami_creation_completed
        event :destroy_image, :transitions_to => :failed
      end
      state :ami_creation_completed do
        event :destroy_image, :transitions_to => :image_destroyed
      end
      state :image_destroyed
      state :failed
    end

    def bake
      create_stack!
      create_ami!
      destroy_stack!
    end

    def create_event(description)
      puts description
    end

    def destroy_image
      #destroy_stack if stack.exists?
      create_event 'De-registering AMI and destroying snapshots.'
      #ec2_destroy_ami.destroy ami
      create_event 'AMI destroyed.'
    end

    def create_stack
      create_event "Creating Cloud Formation Stack."
      #stack.create
      create_event "Waiting for stack build to complete."
      #stack.wait_for_stack_to_complete
      create_event "Stack created."
    end

    def create_ami
      create_event "Creating AMI from stack instance."
      #self.ami = stack.create_ami.image_id
      #save
      create_event "AMI created."
      #wait_for_ami_to_complete
      create_event "AMI creation completed."
    end

    def wait_for_ami_to_complete
      while pending?
        sleep 5
      end
      available?
    end

    def destroy_stack
      create_event "Destroying stack."
      #stack.destroy
      create_event "Stack destroyed."
    end

    def available?
      ami_state == :avaiable
    end

    def pending?
      ami_state == :pending
    end

    def ec2_ami_state
      @ec2_ami_state ||= EC2::AmiState.new :image => self
    end

    def ec2_destroy_ami
      @ec2_destroy_ami ||= EC2::DestroyAmi.new :image => self
    end
  end
end
