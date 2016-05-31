var gulp = require('gulp');
var del = require('del');
var babel = require('gulp-babel');
var sourcemaps = require('gulp-sourcemaps');
 
gulp.task('default', ['rebuild']);

gulp.task('rebuild', ['clean', 'build']);

gulp.task('clean', ['clean:lib', 'clean:test']);

gulp.task('build', ['build:lib', 'build:test']);

[ 'lib', 'test' ].forEach(function(folder){

  gulp.task('clean:' + folder, function(){
    return del(folder);
  });

  gulp.task('build:' + folder, function(){
    return gulp.src('src/' + folder + '/**/*.js')
      .pipe(babel({
        "plugins": [
          "transform-es2015-modules-commonjs",
          "transform-async-to-generator",
          "transform-exponentiation-operator",
          "syntax-trailing-function-commas",
          "transform-es2015-destructuring",
          "transform-object-rest-spread",
          "transform-class-properties",
          "transform-export-extensions",
          "transform-do-expressions",
          "transform-strict-mode",
          "transform-runtime"
        ]
      }))
      .pipe(sourcemaps.write(folder))
      .pipe(gulp.dest(folder));
  });

});
