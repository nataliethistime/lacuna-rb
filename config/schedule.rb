# encoding: utf-8

# Ignore all output because LacunaUtil now has a logger that takes care of all this.
set :output, '/dev/null'

job_type :task, "/usr/local/bin/ruby /home/vasari/lacuna-rb/bin/run.rb :task :output"
job_type :tasks, "/usr/local/bin/ruby /home/vasari/lacuna-rb/bin/run.rb :task :output"

every :hour do
    task 'BuildExcavators'
    task 'UpgradeBuildings --skip "+:: Aragorn ::+" --skip "+:: Gimli ::+" --skip "+:: Legolas ::+"'
    task 'QuickUpgrade --planet "+:: Aragorn ::+"'
    task 'QuickUpgrade --planet "+:: Gimli ::+"'
    task 'QuickUpgrade --planet "+:: Legolas ::+"'
    task 'CleanMail'
end

every :day, :at => '4:20pm' do
    tasks 'InitStars InitExcavators SendExcavators MakeHalls'
end

every :day, :at => '4:55pm' do
    task 'SendLog'
end
