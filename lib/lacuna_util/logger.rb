# encoding: utf-8

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
        STDOUT.puts @messages.last
    end

    def self.error(message)
        klass = self.get_klass(caller)
        @messages << self.format(klass, message)
        # TODO: make this colored red or something!
        STDOUT.puts @messages.last
    end

    def self.debug(message)
        klass = self.get_klass(caller)
        @messages << self.format(klass, message)
    end

    def self.format(klass, message)
        time = Time.now.strftime '%A, %d %B %Y - %H:%M:%S'
        "#{time} (#{klass}): #{message}"
    end

    def self.get_klass(caller)
        # ["/home/vasari/lacuna-rb/lib/lacuna_util/task.rb:21:in `run'"]
        pieces = caller.first.split(':')
        file = pieces.first.split('/').last
        line = pieces[1]
        "#{file}:#{line}"
    end

    def self.init
        @log_path = File.join(LacunaUtil.root, 'log', 'output.log')
    end

    def self.logs_this_run
        (@messages + ["\n\n"]).join "\n"
    end
end

at_exit do
    File.write(Logger.log_path, Logger.logs_this_run, mode: 'a')
end
