module.exports = function(grunt){
	grunt.initConfig({
		pkg: grunt.file.readJSON("package.json"),

		concat: {
			coffee: {
				src: ['dev/coffee/app/module.coffee', 'dev/coffee/app/routes.coffee', 'dev/coffee/app/factories/**/*.coffee','dev/coffee/app/**/*.coffee', 'dev/coffee/app/**/*.coffee'],
				dest: 'dev/coffee/app.coffee',
			}
		},
		coffee: {
			compile: {
				files: {
					'public/app/app.js' : 'dev/coffee/*.coffee'
				}
			}
		},
		sass: {
			dist: {
				options: {
					outputStyle: 'expanded'
				},
				files: {
					'public/stylesheets/style.css' : 'dev/sass/style.scss'
				}
			}
		},
		nodemon: {
			dev: {
				options: {
					file: 'app.js',
					ignoreFiles: ['node_modules/**'],
					watchedExtensions: ['html']
				}
			}
		},
		watch: {
			coffee:{
				files: ['dev/coffee/**/*.coffee'],
				tasks: ['concat','coffee']
			},
			sass:{
				files: ['dev/sass/*.scss'],
				tasks: ['sass']
			}
		},
		concurrent: {
		  target: {
		    tasks: ['nodemon', 'watch:sass', 'watch:coffee'],
		    options: {
		      logConcurrentOutput: true
		    }
		  }
		}
	});

	require('load-grunt-tasks')(grunt);

	grunt.registerTask("default", ["concat","coffee","sass","concurrent"]);
};