# encoding: utf-8

# Ignore all output because LacunaUtil now has a logger that takes care of all this.
set :output, '/dev/null'

job_type :task, "/usr/local/bin/ruby /home/vasari/lacuna-rb/bin/run.rb :task :output"

every :hour do
    task 'UpgradeBuildings'
    task 'CleanMail'
end

every 6.hours do
    task 'MakeHalls'
end

every :reboot do
    task 'InitStars'
    task 'InitExcavators'
end
