gulp    = require 'gulp'
jasmine = require 'gulp-jasmine'
coffee  = require 'gulp-coffee'
uglify  = require 'gulp-uglify'
clean   = require 'gulp-clean'
rename  = require 'gulp-rename'

gulp.task 'build', ->
  gulp.src('./lib/*.js', read: false).pipe clean()

  gulp.src './src/akop.coffee'
    .pipe coffee()
    .pipe gulp.dest './lib'
    .pipe uglify()
    .pipe rename (path) ->
      path.basename += '.min'
      return
    .pipe gulp.dest './lib'
  return