# encoding: utf-8

# Auto flush STDOUT
STDOUT.sync = true

class Logger
    def self.log(message)
        time = Time.now.strftime '%A, %d %B %Y - %H:%M:%S'
        STDOUT.puts "#{time} : #{message}"
    end
end
