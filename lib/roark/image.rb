module Roark
  class Image

    attr_accessor :image_id

    def initialize(args)
      @aws_access_key = args[:aws_access_key]
      @aws_secret_key = args[:aws_secret_key]
      @name           = args[:name]
      @region         = args[:region]
      @logger         = Roark.logger
    end

    def create(args)
      @parameters = args[:parameters]
      @template   = args[:template]

      create_instance
      wait_for_instance
      stop_instance
      wait_for_instance_to_stop
      create_ami
      wait_for_ami
      destroy_instance
      @logger.info "Image created succesfully."
    end

    def state
      ec2_ami_state.state @image_id
    end

    def destroy
      @logger.info "Destroying image '#{@image_id}'."
      ec2_destroy_ami.destroy @image_id
      @logger.info "Destroy completed succesfully."
    end

    private

    def create_instance
      @logger.info "Creating instance."
      instance.create :parameters => @parameters,
                      :template   => @template
      @logger.info "Instance created."
    end

    def create_ami
      @logger.info "Creating AMI '#{@name}' from Instance '#{instance.instance_id}'."
      image = instance.create_ami_from_instance
      @image_id = image.image_id
      @logger.info "Image #{@image_id} created."
    end

    def destroy_instance
      instance.destroy
      @logger.info "Instance destroyed."
    end

    def wait_for_instance_to_stop
      while instance.status != :stopped
        @logger.info "Waiting for instance '#{instance.instance_id}' to stop. Current state: '#{instance.status}'."
        sleep 15
      end
    end

    def wait_for_instance
      while instance.in_progress? || !instance.exists?
        @logger.info "Waiting for instance to come online."
        sleep 15
      end

      if instance.success?
        @logger.info "Instance '#{instance.instance_id}' completed succesfully."
        true
      else
        @logger.info "Instance did not complete succesfully."
        false
      end
    end

    def stop_instance
      @logger.info "Stopping instance."
      instance.stop
    end

    def wait_for_ami
      while pending?
        @logger.info "Waiting for AMI creation to complete. Current state: '#{state}'."
        sleep 15
      end

      if available?
        @logger.info "AMI completed succesfully."
        true
      else
        @logger.info "AMI did not complete succesfully."
        false
      end
    end

    def available?
      state == :available
    end

    def pending?
      state == :pending
    end

    def ec2
      @ec2 ||= Roark::Aws::Ec2::Connection.new.connect :aws_access_key => @aws_access_key,
                                                       :aws_secret_key => @aws_secret_key,
                                                       :region         => @region
    end

    def instance
      @instance ||= Instance.new :aws_access_key => @aws_access_key,
                                 :aws_secret_key => @aws_secret_key,
                                 :name           => @name,
                                 :region         => @region
    end

    def ec2_ami_state
      @ec2_ami_state ||= Roark::Aws::Ec2::AmiState.new ec2
    end

    def ec2_destroy_ami
      @ec2_destroy_ami ||= Roark::Aws::Ec2::DestroyAmi.new ec2
    end

  end
end
