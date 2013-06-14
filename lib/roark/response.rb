module Roark
  class Response
    attr_accessor :code, :message

    def initialize(args={})
      @code    = args.fetch :code, 1
      @message = args.fetch :message, ''
    end

    def success?
      @code == 0
    end

  end
end
