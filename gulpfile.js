var gulp = require('gulp');
var vulcanize = require('gulp-vulcanize');
var minifyInline = require('gulp-minify-inline');

gulp.task('copy', function() {
  return gulp.src([
      'app/index.html',
      'app/reflex.css',
      'app/bower_components/webcomponentsjs/webcomponents-lite.min.js'
    ], {
      base: 'app'
    })
    .pipe(gulp.dest('dist'));
});

gulp.task('vulcanize', function() {
  return gulp.src('app/elements/elements.html')
    .pipe(vulcanize({
      stripComments: true,
      inlineScripts: true,
      inlineCss: true
    }))
    .pipe(minifyInline())
    .pipe(gulp.dest('dist/elements/'));
});


gulp.task('default', ['copy', 'vulcanize' ]);
