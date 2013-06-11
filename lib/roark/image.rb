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
    end

    def destroy
      instance.destroy
    end

    private

    def instance
      @instance ||= Instance.new :aws_access_key => @aws_access_key,
                                 :aws_secret_key => @aws_secret_key,
                                 :name           => @name,
                                 :region         => @region
    end

  end
end
