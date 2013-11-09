module.exports = function(grunt){
	grunt.initConfig({
		pkg: grunt.file.readJSON("package.json"),

		concat: {
			coffee: {
				src: ['dev/coffee/app/module.coffee', 'dev/coffee/app/routes.coffee', 'dev/coffee/app/**/*.coffee', 'dev/coffee/app/**/*.coffee'],
				dest: 'dev/coffee/app.coffee',
			}
		},
		coffee: {
			compile: {
				files: {
					'public/app/app.js': 'dev/coffee/*.coffee'
				}
			}
		},
		sass: {
			dist: {
				files: {
					'public/stylesheets/style.css': 'dev/sass/style.scss'
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
			js:{
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
		    tasks: ['nodemon', 'watch'],
		    options: {
		      logConcurrentOutput: true
		    }
		  }
		}
	});
	grunt.loadNpmTasks('grunt-contrib-concat');

	grunt.loadNpmTasks('grunt-nodemon');

	grunt.loadNpmTasks('grunt-contrib-coffee');

	grunt.loadNpmTasks('grunt-contrib-watch');

	grunt.loadNpmTasks('grunt-concurrent');

	grunt.loadNpmTasks('grunt-contrib-sass');

	grunt.registerTask("default", ["concat","coffee", "sass", "concurrent"]);
};