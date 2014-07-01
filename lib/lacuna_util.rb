# encoding: utf-8

$LOAD_PATH.unshift File.dirname __FILE__

require 'require_all'
require 'json'
require 'sequel'

require 'lacuna_util/version'
require 'lacuna_util/logger'

class LacunaUtil
    @@tasks = {}
    @config = {}
    @root   = ''
    @db     = {}

    class << self
        attr_accessor :config
        attr_accessor :root
        attr_accessor :db
    end

    def self.register_task(task_class)
        @@tasks[task_class.to_s] = task_class
    end

    def self.task(name)
        t = @@tasks[name]

        unless t.nil?
            t
        else
            Logger.log "No '#{name}' task!"
            exit
        end
    end

    def self.has_task?(tname)
        !@@tasks[tname].nil?
    end
end

 # There's pro'lly a better way to do this...
arr = File.dirname(__FILE__).split File::SEPARATOR
arr -= Array(arr.last)
LacunaUtil.root = arr.join File::SEPARATOR

# LOAD ALL THE CONFIGURATION OPTIONS!
LacunaUtil.config = JSON.parse File.read File.join(LacunaUtil.root, 'config.json')
LacunaUtil.db = Sequel.sqlite(File.join(LacunaUtil.root, 'lacuna_util.db'))

Logger.init

# Load all the tasks and db tables
require_all File.join(LacunaUtil.root, 'lib', 'lacuna_util', 'tables')
require_all File.join(LacunaUtil.root, 'lib', 'lacuna_util', 'task')
