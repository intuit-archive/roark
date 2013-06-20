module Roark
  class AmiCreateWorkflow

    def initialize(args)
      @account_ids = args[:account_ids]
      @ami         = args[:ami]
      @tags        = args[:tags]
      @parameters  = args[:parameters]
      @template    = args[:template]
      @logger      = Roark.logger
    end

    def execute
      %w(create_instance wait_for_instance stop_instance wait_for_instance_to_stop
         create_ami wait_for_ami destroy_instance add_tags authorize_account_ids).each do |m|
        response = self.send m.to_sym
        return response unless response.success?
      end
      Response.new :code => 0, :message => "AMI create workflow completed succesfully."
    end

    def create_instance
      @ami.create_instance :parameters => @parameters,
                           :template   => @template
    end

    def wait_for_instance
      @ami.wait_for_instance
    end

    def stop_instance
      @ami.stop_instance
    end

    def wait_for_instance_to_stop
      @ami.wait_for_instance_to_stop
    end

    def create_ami
      @ami.create_ami
    end

    def wait_for_ami
      @ami.wait_for_ami
    end

    def destroy_instance
      @ami.destroy_instance
    end

    def add_tags
      @ami.add_tags @tags
    end

    def authorize_account_ids
      @ami.authorize_account_ids @account_ids
    end

  end
end
