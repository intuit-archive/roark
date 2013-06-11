module Roark
  class Image

    def initialize(args)
      @aws_access_key = args[:aws_access_key]
      @aws_secret_key = args[:aws_secret_key]
      @name           = args[:name]
      @region         = args[:region]
    end

    def create(args)
      @parameters = args[:parameters]
      @template   = args[:template]
      instance.create :parameters => @parameters,
                      :template   => @template
      instance.wait_for_instance
      instance.create_ami_from_instance
      instance.destroy_instance
    end

    def destroy
      true
    end

    def wait_for_instance
      while instance.in_progress?
        sleep 5
      end
      instance.success?
    end

    private

    def instance_id
      stack.instance_id
    end

    def instance
      @instance ||= Instance.new :aws_access_key => @aws_access_key,
                                 :aws_secret_key => @aws_secret_key,
                                 :name           => @name,
                                 :region         => @region
    end

  end
end
