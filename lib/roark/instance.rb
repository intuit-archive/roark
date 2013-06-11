module Roark
  class Instance

    def initialize(args)
      @aws_access_key = args[:aws_access_key]
      @aws_secret_key = args[:aws_secret_key]
      @name           = args[:name]
      @region         = args[:region]
    end

    def create(args)
      parameters = args[:parameters]
      template   = args[:template]

      unless exists?
        stack.create :name       => @name,
                     :parameters => parameters,
                     :template   => template
      end

      stack.success? ? instance_id : false
    end

    def create_ami_from_instance
      create_ami.create :name        => @name,
                        :instance_id => instance_id
    end

    def destroy
      stack.destroy
    end

    def in_progress?
      stack.in_progress?
    end

    def success?
      stack.success?
    end

    def instance_id
      stack.instance_id
    end

    def exists?
      stack.exists?
    end

    private

    def stack
      @stack ||= Stack.new :aws_access_key => @aws_access_key,
                           :aws_secret_key => @aws_secret_key,
                           :name           => @name,
                           :region         => @region
    end

    def connection
      @connection ||= Roark::Aws::Ec2::Connection.new.connect :aws_access_key => @aws_access_key,
                                                              :aws_secret_key => @aws_secret_key,
                                                              :region         => @region
    end

    def create_ami
      @create_ami ||= Roark::Aws::Ec2::CreateAmi.new connection
    end
  end
end
