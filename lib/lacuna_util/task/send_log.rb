# encoding: utf-8

require 'optparse'

require 'lacuna_util/task'
require 'lacuna_util/logger'

class SendLog < LacunaUtil::Task

    def args
    end

    def _run(args, config)
        Logger.log "Loading all log entries from #{Logger.log_path}"

        log = File.read(Logger.log_path)
        to_send = self.prepare(log)
        Lacuna::Inbox.send_message(config['name'], 'Daily Log', to_send)

        # Now clear out the log
        File.write(Logger.log_path, '')
    end

    def prepare(log)
        # The body of the message can't be more than 200k of chars long and cannot
        # contain '<' or '>'.
        limit = 200_000
        if log.size > limit
            log = log[0, limit]
        end
        log.gsub!(/\<|\>/, '')
        log
    end
end

LacunaUtil.register_task SendLog
