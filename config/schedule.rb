# encoding: utf-8

set :output, "/home/vasari/lacuna-rb/log/output.log"
job_type :task, "/usr/local/bin/ruby /home/vasari/lacuna-rb/bin/run.rb :task :output"

every :hour do
    task 'UpgradeBuildings --skip "-= The Shire =-"'
    task 'CleanMail'
end

every 6.hours do
    task 'MakeHalls'
end

# Shortly after every server reset (in GMT+10 time)
every 1.day, :at => '10:10 am' do
    task 'InitStars'
    task 'InitExcavators'
end
