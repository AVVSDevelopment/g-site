/*global module:false*/
module.exports = function(grunt) {

    grunt.initConfig({
        less: {
            development: {
                options: {
                    paths: ["source/static/less"]
                },
                files: {
                    "source/static/css/app.css": "source/static/less/app.less"
                }
            }
        },
        cssmin: {
            compress: {
                files: {
                    "source/static/css/app.concat.css": ["source/static/css/app.css"],
                    "source/static/css/typicons.min.css": ["source/static/css/typicons.css"]

                }
            }
        },
        concat: {
            dist: {
                src: ["source/static/css/bootstrap.min.css", "source/static/css/bootstrap-resonsive.min.css",
                    "source/static/css/typicons.min.css", "source/static/css/app.concat.css"
                ],
                dest: "source/static/css/app.min.css"
            }
        },
        coffee : {
            compile: {
                files : {
                    'source/static/js/app.body.js':["source/client/models/*.coffee", "source/client/collections/*.coffee",
                        "source/client/views/**/**.coffee", "source/client/app.coffee"
                    ]
                },
                options: {
                    bare: true
                }
            }
        },
        uglify : {
            head: {
                files : {
                    "source/static/js/app.head.js" :["source/static/js/jquery-1.9.1.min.js", "source/static/js/underscore.js",
                        "source/static/js/backbone.js", "source/static/js/infiniScroll.js", "source/static/js/dot.min.js",
                        "source/static/js/swfobject.js"
                    ]
                }
            }
            /*,
            body: {
                files: {
                    "source/static/js/app.body.js": ["source/static/js/coffee.js"]
                }
            } */
        },

        watch : {
            less: {
                files: ['source/static/less/*.less'],
                tasks: ['less', 'cssmin', 'concat'],
                options: {
                    interrupt: true
                }
            },
            coffee: {
                files: ['source/client/**.coffee'],
                tasks: ['coffee'],
                options: {
                    interrupt: true
                }
            }
        }
    });


    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.registerTask('default', ['less', 'cssmin', 'concat', 'uglify', 'coffee']);

};


