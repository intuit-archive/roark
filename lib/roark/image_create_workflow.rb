module Roark
  class ImageCreateWorkflow

    def initialize(args)
      @image      = args[:image]
      @parameters = args[:parameters]
      @template   = args[:template]
      @logger     = Roark.logger
    end

    def execute
      %w(create_instance wait_for_instance stop_instance wait_for_instance_to_stop
         create_ami wait_for_ami destroy_instance).each do |m|
        response = self.send m.to_sym
        return response unless response.success?
      end
      Response.new :code => 0, :message => "Image create workflow completed succesfully."
    end

    def create_instance
      @image.create_instance :parameters => @parameters,
                             :template   => @template
    end

    def wait_for_instance
      @image.wait_for_instance
    end

    def stop_instance
      @image.stop_instance
    end

    def wait_for_instance_to_stop
      @image.wait_for_instance_to_stop
    end

    def create_ami
      @image.create_ami
    end

    def wait_for_ami
      @image.wait_for_ami
    end

    def destroy_instance
      @image.destroy_instance
    end

  end
end
