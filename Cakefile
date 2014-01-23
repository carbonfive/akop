fs = require 'fs'
{exec} = require 'child_process'

appFiles = [
  'module'
  'keymap/module'
  'keymap/keymap_utils'
  'multi_select/module'
  'multi_select/multi_select'
  'multi_select/multi_select_directive'
  'query_filter/module'
  'query_filter/query_filter'
  'query_filter/query_parser'
]

specFiles = [
  'factories/event_factory'
  'keypress_utils_spec'
  'multi_select/multi_select_spec'
  'multi_select/multi_select_directive_spec'
  'query_filter/query_filter_spec'
  'query_filter/query_parser_spec'
]

task 'build', 'Build single application file from source files', ->
  appContents = new Array remaining = appFiles.length
  for file, index in appFiles then do (file, index) ->
    fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'lib/akop.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee --compile lib/akop.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink 'lib/akop.coffee', (err) ->
          throw err if err
          console.log 'Done.'

task 'build:specs', 'Build single spec file', ->
  specContents = new Array remaining = specFiles.length
  for file, index in specFiles then do (file, index) ->
    fs.readFile "spec/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      specContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'spec/lib/akop_specs.coffee', specContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee --compile spec/lib/akop_specs.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink 'spec/lib/akop_specs.coffee', (err) ->
          throw err if err
          console.log 'Done.'

task 'spec', 'Build source and spec files and launch spec runner in a browser', ->
  exec 'cake build build:specs'
  exec 'open SpecRunner.html'

task 'minify', 'Minify the resulting application file after build', ->
  # TODO: add param for path to compiler (google js minifier)
  exec 'java -jar "../../tools/compiler.jar" --js lib/akop.js --js_output_file lib/akop.min.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
