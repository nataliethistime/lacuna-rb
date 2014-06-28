# encoding: utf-8

require 'lacuna'
require 'lacuna_util/logger'

class LacunaUtil
    class Task

        def initialize
            Lacuna.connect({
                :name        => LacunaUtil.config['name'],
                :password    => LacunaUtil.config['password'],
                :server_name => LacunaUtil.config['server_name'] || 'us1',
            })
        end

        def run
            task_name = self.class
            name = LacunaUtil.config['name']
            print "\n"
            Logger.log "Running task #{task_name} as #{name}"
            print "\n"
            self._run(self.args || {}, LacunaUtil.config)
        end
    end
end
