# encoding: utf-8

set :output, ''
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
