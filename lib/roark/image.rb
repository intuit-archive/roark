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

      @logger.info "Creating instance."
      instance.create :parameters => @parameters,
                      :template   => @template
      wait_for_instance
      create_ami
      wait_for_ami
      instance.destroy if instance.exists?
    end

    def create_ami
      @logger.info "Creating AMI."
      instance.create_ami_from_instance
    end

    def wait_for_instance
      while instance.in_progress? || !instance.exists?
        @logger.info "Waiting for instance to come online."
        sleep 5
      end
      instance.success?
    end

    def image_id
      @image_id ||= Roark::Aws::Ec2::FindAmi.new(connection).find @name
    end

    def wait_for_ami
      while pending?
        @logger.info "Waiting for AMI creation to complete."
        sleep 5
      end
      available?
    end

    private

    def available?
      ami_state == :avaiable
    end

    def pending?
      ami_state == :pending
    end

    def ami_state
      ec2_ami_state.state image_id
    end

    def available?
      ami_state == :avaiable
    end

    def pending?
      ami_state == :pending
    end

    def instance_id
      stack.instance_id
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
