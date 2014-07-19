# encoding: utf-8

here = File.expand_path(File.dirname(__FILE__))
load_path = File.join(here, '..', 'lib', 'lacuna_util.rb')
require load_path

# ARGV should only be a list of tasks, eg: ruby run.rb CleanMail UpgradeBuildings
tasks = ARGV
to_run = []

# Preemptively check each task the user specifies and try to report errors.
tasks.each do |name|

    unless LacunaUtil.has_task? name
        next
    end

    to_run << LacunaUtil.task(name)
end


to_run.each do |lets_go|
    lets_go.new.run
end
