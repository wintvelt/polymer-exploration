var gulp = require('gulp');
var vulcanize = require('gulp-vulcanize');
var minifyInline = require('gulp-minify-inline');

var elm = require('gulp-elm');
var plumber = require('gulp-plumber');
var gutil = require("gulp-util");

var paths = {
  dest: 'dist',
  dest_assets: 'dist/assets',
  main_elm: 'src/Main.elm'
};

gulp.task('elm-init', elm.init);

gulp.task('elm-bundle', ['elm-init'], function(){
  return gulp.src(paths.main_elm)
    .pipe(elm.bundle('elm.js').on('error', gutil.log))
    .pipe(gulp.dest(paths.dest_assets));
});

gulp.task('copyHtml', function() {
  return gulp.src([
      'src/index.html'
    ], {
      base: 'src'
    })
    .pipe(gulp.dest(paths.dest));
});

gulp.task('copyWC', function() {
  return gulp.src([
      'bower_components/webcomponentsjs/webcomponents-lite.min.js'
     ])
    .pipe(gulp.dest(paths.dest_assets));
});

gulp.task('vulcanize', function() {
  return gulp.src('src/elements.html')
    .pipe(vulcanize({
      stripComments: true,
      inlineScripts: true,
      inlineCss: true
    }))
    .pipe(minifyInline())
    .pipe(gulp.dest(paths.dest_assets));
});


gulp.task('default', ['copyHtml', 'copyWC', 'elm-bundle', 'vulcanize' ]);
