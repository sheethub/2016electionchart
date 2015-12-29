# ulimit -S -n 2048

require! {
	"gulp"
	"gulp-livescript"
	"gulp-uglify"
	"gulp-rename"
	"gulp-imagemin"
	"imagemin-pngcrush"
	"gulp-gm"
	"gulp-stylus"
	"gulp-jade"
}

gulp.task "js-min" ->
	gulp.src "./js/*.ls"
		.pipe gulp-livescript bare: false, prelude: true
		.pipe gulp-uglify!
		.pipe gulp.dest "./js/"
		.pipe gulp-rename extname: ".min.js"
		.pipe gulp.dest "./js/"

gulp.task "reimg" ->
		gulp.src "./image/*"
			.pipe(gulp-imagemin({
				optimizationLevel: 6
				progressive: true
				svgoPlugins: [{removeViewBox: false}]
				use: [imagemin-pngcrush!]
			}))
			.pipe gulp.dest "./reimg/"

gulp.task "smlimg" ->
		gulp.src "./reimg/*"
			.pipe gulp-gm ->
				it.resize 100
			.pipe gulp.dest "smlimg"


gulp.task "js-dev" ->
	gulp.src "./js/*.ls"
		.pipe gulp-livescript bare: true, prelude: true
		.pipe gulp.dest "./js/"

gulp.task "css-dev" ->
	gulp.src "./css/*.styl"
		.pipe gulp-stylus!
		.pipe gulp.dest "./css/"


gulp.task "jd-dev" ->
	gulp.src "*.jade"
		.pipe gulp-jade pretty: true
		.pipe gulp.dest "."

gulp.task "watch" -> 
	gulp.watch "./js/*.ls", ["js-dev"]
	gulp.watch "./css/*.styl", ["css-dev"]
	gulp.watch "*.jade", ["jd-dev"]

	

gulp.task "default" ["watch"]