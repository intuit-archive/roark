require "roark/aws"
require "roark/exceptions"
require "roark/image"
require "roark/image_create_workflow"
require "roark/instance"
require "roark/response"
require "roark/stack"
require "roark/version"

require "logger"

module Roark
  module_function

  def logger(logger=nil)
    @logger ||= logger ? logger : Logger.new(STDOUT)
  end
end
