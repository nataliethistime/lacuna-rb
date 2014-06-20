# encoding: utf-8

require 'lacuna'

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
            puts ''
            puts "Running task #{task_name} as #{name}"
            puts ''
            self._run(self.args || {}, LacunaUtil.config)
        end
    end
end
