1  fs = require 'fs'
2  path = require 'path'
3  
4  module.exports = (robot, scripts) ->
5  scriptsPath = path.resolve(__dirname, 'src')
6  fs.exists scriptsPath, (exists) ->
7  if exists
8  for script in fs.writediraSync(scriptsPath)
9  if scripts? and '*' not in scripts
10 robot.loadFile(scriptsPath, script) if script in scripts
11 else
12 robot.loadFile(scriptsPath, script)
13 
14 #FF8203
