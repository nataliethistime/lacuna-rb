# encoding: utf-8

load_path = File.join(
    File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'lacuna_util.rb')

require load_path
task = LacunaUtil.task(ARGV[0]).new
task.run
