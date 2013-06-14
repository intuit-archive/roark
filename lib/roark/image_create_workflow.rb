module Roark
  class ImageCreateWorkflow

    def initialize(args)
      @image      = args[:image]
      @parameters = args[:parameters]
      @template   = args[:template]
      @logger     = Roark.logger
    end

    def execute
      create_instance
      wait_for_instance
      stop_instance
      wait_for_instance_to_stop
      create_ami
      wait_for_ami
      destroy_instance
      @logger.info "Image create workflow completed succesfully."
    end

    def create_instance
      response = @image.create_instance :parameters => @parameters,
                                        :template   => @template
      unless response.success?
        raise Roark::Exceptions::ImageCreateWorkflowError.new response.message
      end
    end

    def wait_for_instance
      @image.wait_for_instance
    end

    def stop_instance
      response = @image.stop_instance
      unless response.success?
        raise Roark::Exceptions::ImageCreateWorkflowError.new response.message
      end
    end

    def wait_for_instance_to_stop
      @image.wait_for_instance_to_stop
    end

    def create_ami
      response = @image.create_ami
      unless response.success?
        raise Roark::Exceptions::ImageCreateWorkflowError.new response.message
      end
    end

    def wait_for_ami
      @image.wait_for_ami
    end

    def destroy_instance
      response = @image.destroy_instance
      unless response.success?
        raise Roark::Exceptions::ImageCreateWorkflowError.new response.message
      end
    end

  end
end
