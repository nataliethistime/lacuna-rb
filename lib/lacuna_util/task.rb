# encoding: utf-8

require 'lacuna'
require 'lacuna_util/logger'

class LacunaUtil
    class Task

        attr_accessor :args
        attr_accessor :config

        def initialize
            Lacuna.connect({
                :name        => LacunaUtil.config['name'],
                :password    => LacunaUtil.config['password'],
                :server_name => LacunaUtil.config['server_name'] || 'us1',
            })

            @args = self.args() || {}
            @config = LacunaUtil.config
        end

        def run
            Logger.space
            Logger.log "Running task #{self.class} as #{@config['name']}"
            Logger.space
            self._run(@args, @config)
        end
    end
end
