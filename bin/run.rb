# encoding: utf-8

here = File.expand_path(File.dirname(__FILE__))
load_path = File.join(here, '..', 'lib', 'lacuna_util.rb')
require load_path

# ARGV should only be a list of tasks, eg: ruby run.rb CleanMail UpgradeBuildings
tasks = ARGV
to_run = []

# Preemptively check each task the user specifies and try to report errors.
tasks.each do |name|
    # LacunaUtil will stop the script if the task doesn't exist
    task = LacunaUtil.task(name)

    # If we didn't get any errors, push it into the array that will get run through later.
    to_run << task
end


to_run.each do |lets_go|
    lets_go.new.run
end
