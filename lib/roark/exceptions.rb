module Roark
  module Exceptions

    class Base < RuntimeError
      attr_accessor :message

      def initialize(message="")
        @message = message
      end
    end

    class ImageCreateWorkflowError < Base
    end

  end
end
