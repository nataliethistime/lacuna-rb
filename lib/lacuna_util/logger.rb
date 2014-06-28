# encoding: utf-8

# Auto flush STDOUT
STDOUT.sync = true

class Logger
    @messages = []

    class << self
        attr_reader :messages
    end

    def self.log(message)
        klass = self.get_klass(caller)
        @messages << self.format(klass, message)
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
end

at_exit do
    # Write all the messages to the log file
    path = File.join(LacunaUtil.root, 'log', 'output.log')
    # Add some newlines to the end for ease of reading.
    File.write(path, (Logger.messages + ["\n\n"]).join("\n"), mode: 'a')
end
