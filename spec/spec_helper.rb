require 'rubygems'
require 'bundler/setup'

require 'roark'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'helpers', '*.rb'))].each do |f|
  require f
end

RSpec.configure do |config|
  config.include Fixtures
end
