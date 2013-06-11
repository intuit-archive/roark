module Roark
  class Image

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

      @logger.info "Creating instance to image."
      instance.create :parameters => @parameters,
                      :template   => @template
      @logger.info "Instance created."

      wait_for_instance
      stop_instance
      wait_for_instance_to_stop
      create_ami
      wait_for_ami
      instance.destroy
    end

    def create_ami
      @logger.info "Creating AMI."
      instance.create_ami_from_instance
      @logger.info "AMI creation submited."
    end

    def wait_for_instance_to_stop
      while instance.status != :stopped
        @logger.info "Waiting for instance #{instance.instance_id} to stop.  Currently #{instance.status}."
        sleep 15
      end
    end

    def wait_for_instance
      while instance.in_progress? || !instance.exists?
        @logger.info "Waiting for instance to come online.  Currently #{instance.status}."
        sleep 15
      end

      if instance.success?
        @logger.info "Instance #{instance.instance_id} completed succesfully."
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

    def image_id
      Roark::Aws::Ec2::FindAmi.new(connection).find @name
    end

    def wait_for_ami
      while pending?
        @logger.info "Waiting for AMI creation to complete."
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

    private

    def ami_state
      ec2_ami_state.state image_id
    end

    def available?
      ami_state == :avaiable
    end

    def pending?
      ami_state == :pending
    end

    def connection
      @connection ||= Roark::Aws::Ec2::Connection.new.connect :aws_access_key => @aws_access_key,
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
      @ec2_ami_state ||= Roark::Aws::Ec2::AmiState.new connection
    end

    def ec2_destroy_ami
      @ec2_destroy_ami ||= Roark::Aws::Ec2::DestroyAmi.new connection
    end

  end
end
