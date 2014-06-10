#  encoding: utf-8

# Fix this path stuff!
require './../lib/lacuna_util'

task = LacunaUtil.task('UpgradeBuildings').new
task.run
