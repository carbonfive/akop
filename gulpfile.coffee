gulp    = require 'gulp'
jasmine = require 'gulp-jasmine'
coffee  = require 'gulp-coffee'
uglify  = require 'gulp-uglify'
clean   = require 'gulp-clean'
rename  = require 'gulp-rename'
concat  = require 'gulp-concat'

gulp.task 'build', ->
  gulp.src('./lib/*.js', read: false).pipe clean()

  gulp.src ['./src/module.coffee', './src/**/*.coffee']
    .pipe coffee()
    .pipe concat('akop.js')
    .pipe gulp.dest './lib'
    .pipe uglify()
    .pipe rename (path) ->
      path.basename += '.min'
      return
    .pipe gulp.dest './lib'
  return

gulp.task 'build-vendor', ->
  gulp.src './vendor/*.js'
    .pipe concat 'vendor.js'
    .pipe gulp.dest './vendor'
  return

gulp.task 'build-specs', ->
  gulp.src ['./spec/module.coffe', './spec/**/module.coffee', './spec/**/*_spec.coffee']
    .pipe coffee()
    .pipe concat('spec.js')
    .pipe gulp.dest './spec'

gulp.task 'spec', ['build', 'build-vendor', 'build-specs'], ->
  gulp.src(['./vendor/vendor.js','./lib/akop.min.js','spec/spec.js']).pipe(jasmine());