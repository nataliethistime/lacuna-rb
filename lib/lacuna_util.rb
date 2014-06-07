# encoding: utf-8

$LOAD_PATH.unshift File.dirname __FILE__

require 'require_all'
require 'json'

require 'lacuna_util/version'

class LacunaUtil
    @@tasks = {}
    @@config = {}

    def self.config
        @@config
    end

    def self.config=(obj)
        @@config = obj
    end

    def self.register_task(task_class)
        @@tasks[task_class.to_s] = task_class
    end

    def self.task(name)
        @@tasks[name]
    end

    def self.has_task?(tname)
        !@@tasks[tname].nil?
    end
end

# LOAD ALL THE CONFIGURATION OPTIONS!
path = File.join(File.dirname(__FILE__), '..', 'config.json')
LacunaUtil.config = JSON.parse File.read path

# Load all the tasks
require_all File.join(File.dirname(__FILE__), 'lacuna_util', 'task')
