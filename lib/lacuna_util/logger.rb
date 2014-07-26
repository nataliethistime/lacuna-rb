# encoding: utf-8

require 'colorize'
require 'fileutils'

# Auto flush STDOUT
STDOUT.sync = true

class Logger
    @messages = []
    @log_path = ''

    class << self
        attr_reader :messages
        attr_accessor :log_path
    end

    def self.log(message)
        klass = self.get_klass(caller)
        @messages << self.format(klass, message)
        STDOUT.puts @messages.last.colorize :green
    end

    def self.log_raw(message)
        @messages << message
        STDOUT.puts message
    end

    def self.error(message)
        klass = self.get_klass(caller)
        @messages << self.format(klass, message)
        STDOUT.puts @messages.last.colorize :red
    end

    def self.debug(message)
        klass = self.get_klass(caller)
        @messages << self.format(klass, message)
    end

    def self.space
        @messages << "\n"
        print "\n"
    end

    def self.format(klass, message)
        time = Time.now.strftime '%d/%m|%H:%M:%S'
        "#{time}~#{klass}: #{message}"
    end

    def self.get_klass(caller)
        # ["/home/vasari/lacuna-rb/lib/lacuna_util/task.rb:21:in `run'"]
        pieces = caller.first.split(':')
        file = pieces.first.split('/').last
        line = pieces[1]
        "#{file}:#{line}"
    end

    def self.init
        dir = File.join(LacunaUtil.root, 'log')
        FileUtils.mkdir_p dir
        @log_path = File.join(dir, 'output.log')
    end

    def self.logs_this_run
        (@messages + ["\n\n"]).join "\n"
    end
end

at_exit do
    File.write(Logger.log_path, Logger.logs_this_run, mode: 'a')
    # TODO: when an error is thrown, it's not displayed in the log.
end
