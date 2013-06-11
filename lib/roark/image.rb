module Roark
  class Image

    def initialize(args)
      @aws_access_key = args[:aws_access_key]
      @aws_secret_key = args[:aws_secret_key]
      @name           = args[:name]
      @region         = args[:region]
    end

    def bake(args)
      @source_ami = args[:source_ami]
      @template   = args[:template]
      bakery = Bakery.new :aws_access_key => @aws_access_key,
                          :aws_secret_key => @aws_secret_key,
                          :name           => @name,
                          :region         => @region
      bakery.bake :source_ami => @source_ami,
                  :template   => @template
    end

  end
end
