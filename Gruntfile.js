module.exports = function(grunt){
	grunt.initConfig({
		pkg: grunt.file.readJSON("package.json"),

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
				files: ['dev/coffee/*.coffee'],
				tasks: ['coffee']
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
	grunt.loadNpmTasks('grunt-nodemon');
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-concurrent');
	grunt.loadNpmTasks('grunt-contrib-sass');

	grunt.registerTask("default", ["coffee", "sass", "concurrent"]);
};