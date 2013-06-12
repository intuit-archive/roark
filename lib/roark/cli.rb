require 'optparse'

require 'roark/cli/shared'

require 'roark/cli/create'
require 'roark/cli/destroy'

module Roark
  module CLI

    def self.start
      cmd = ARGV.shift

      case cmd
      when 'create'
        begin
          CLI::Create.new.create
        rescue OptionParser::MissingArgument => e
          puts e.message
          exit 1
        end
      when 'destroy'
        begin
          CLI::Destroy.new.destroy
        rescue OptionParser::MissingArgument => e
          puts e.message
          exit 1
        end
      when '-h'
        usage
      when '-v'
        puts Roark::VERSION
      else
        puts "Unknown command: '#{cmd}'."
        puts ''
        usage
        exit 1
      end
    end

    def self.usage
      puts 'Usage: roark command'
      puts ''
      puts 'Append -h for help on specific subcommand.'
      puts ''

      puts 'Commands:'
      commands.each do |cmd|
        $stdout.printf "    %-#{length_of_longest_command}s      %s\n",
                       cmd.command_name,
                       cmd.command_summary
      end
    end

    def self.commands
      return @commands if @commands
      klasses   = Roark::CLI.constants.reject {|c| [:Shared].include? c}
      @commands = klasses.map { |klass| Roark::CLI.const_get(klass).new }
    end

    def self.length_of_longest_command
      commands.map { |c| c.command_name.length }.max
    end

  end
end
