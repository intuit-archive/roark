module Roark
  class Image

    attr_accessor :aws, :image_id, :name

    def initialize(args)
      @aws      = args[:aws]
      @image_id = args[:image_id]
      @name     = args[:name]

      @region   = @aws.region
      @logger   = Roark.logger
    end

    def create_instance(args)
      @logger.info "Creating instance in '#{@region}'."
      begin
        instance.create :parameters => args[:parameters],
                        :template   => args[:template]
      rescue AWS::Errors::Base => e
        return Response.new :code => 1, :message => e.message
      end

      @logger.info "Instance created."
      Response.new :code => 0, :message => 'Instance created.'
    end

    def create_ami
      @logger.info "Creating AMI '#{@name}' from Instance '#{instance_id}'."
      begin
        image = instance.create_ami_from_instance
        @image_id = image.image_id
      rescue AWS::Errors::Base => e
        return Response.new :code => 1, :message => e.message
      end
      @logger.info "Image '#{@image_id}' created."
      Response.new :code => 0, :message => "Image '#{@image_id}' created."
    end

    def stop_instance
      @logger.info "Stopping instance."
      begin
        instance.stop
      rescue AWS::Errors::Base => e
        return Response.new :code => 1, :message => e.message
      end
      Response.new :code => 0, :message => "Instance stopped."
    end

    def destroy_instance
      begin
        instance.destroy
      rescue AWS::Errors::Base => e
        return Response.new :code => 1, :message => e.message
      end
      @logger.info "Instance destroyed."
      Response.new :code => 0, :message => "Instance destroyed."
    end

    def destroy
      @logger.info "Destroying image '#{@image_id}'."
      begin
        ec2_destroy_ami.destroy @image_id
      rescue AWS::Errors::Base, AWS::Core::Resource::NotFound => e
        return Response.new :code => 1, :message => e.message
      end
      @logger.info "Destroy completed succesfully."
      Response.new :code => 0, :message => "Destroy completed succesfully."
    end

    def wait_for_instance
      while instance.in_progress? || !instance.exists?
        @logger.info "Waiting for instance to come online."
        sleep 15
      end

      if instance.success?
        @logger.info "Instance '#{instance_id}' completed succesfully."
        true
      else
        @logger.info "Instance did not complete succesfully."
        false
      end
    end

    def wait_for_instance_to_stop
      while instance.status != :stopped
        @logger.info "Waiting for instance '#{instance_id}' to stop. Current state: '#{instance.status}'."
        sleep 15
      end
    end

    def wait_for_ami
      while !exists? || pending?
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

    def exists?
      ec2_ami_state.exists? @image_id
    end

    def state
      ec2_ami_state.state @image_id
    end

    def instance_id
      instance.instance_id
    end

    private

    def instance
      @instance ||= Instance.new :aws => @aws, :name => @name
    end

    def ec2_ami_state
      @ec2_ami_state ||= Roark::Aws::Ec2::AmiState.new @aws
    end

    def ec2_destroy_ami
      @ec2_destroy_ami ||= Roark::Aws::Ec2::DestroyAmi.new @aws
    end

  end
end
