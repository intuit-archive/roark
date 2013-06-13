module Roark
  class ImageCreateWorkflow

    def initialize(image)
      @image  = image
      @logger = Roark.logger
    end

    def execute(args)
      @image.create_instance :parameters => args[:parameters],
                             :template   => args[:template]
      @image.wait_for_instance
      @image.stop_instance
      @image.wait_for_instance_to_stop
      @image.create_ami
      @image.wait_for_ami
      @image.destroy_instance
      @logger.info "Image create workflow completed succesfully."
    end

  end
end
