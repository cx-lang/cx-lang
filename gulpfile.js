var gulp = require('gulp');
var del = require('del');
var babel = require('gulp-babel');
var sourcemaps = require('gulp-sourcemaps');
 
gulp.task('default', ['rebuild']);

gulp.task('rebuild', ['clean', 'build']);

gulp.task('clean', ['clean:lib', 'clean:test']);

gulp.task('build', ['build:lib', 'build:test']);

[ 'lib', 'test' ].forEach(function(folder){

  var paths = ['src/' + folder + '/**/*.js'];

  gulp.task('clean:' + folder, function(){
    return del(paths);
  });

  gulp.task('build:' + folder, function(){
    return gulp.src(paths)
      .pipe(babel(require('./src/.babelrc')))
      .pipe(sourcemaps.write(folder))
      .pipe(gulp.dest(folder));
  });

});
