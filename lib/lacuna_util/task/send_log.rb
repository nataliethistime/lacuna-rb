# encoding: utf-8

require 'optparse'

require 'lacuna_util/task'
require 'lacuna_util/logger'

class SendLog < LacunaUtil::Task

    def args
    end

    def _run(args, config)
    end
end

LacunaUtil.register_task SendLog
