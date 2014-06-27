# encoding: utf-8

set :output, "/home/vasari/lacuna-rb/log/output.log"
job_type :task, "/usr/local/bin/ruby /home/vasari/lacuna-rb/bin/run.rb :task :output"

every :hour do
    task 'UpgradeBuildings'
    task 'CleanMail'
end

every 6.hours do
    task 'MakeHalls'
end

# Shortly after every server reset (in GMT+10 time)
every :reboot do
    task 'InitStars'
    task 'InitExcavators'
end
