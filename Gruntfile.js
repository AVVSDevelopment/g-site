/*global module:false*/
module.exports = function(grunt) {

    grunt.initConfig({
        less: {
            development: {
                options: {
                    paths: ["source/static/less"]
                },
                files: {
                    "source/static/css/app.css": "source/static/less/app.less",
                    "source/static/css/admin.css": "source/static/less/admin.less"
                }
            }
        },
        cssmin: {
            compress: {
                files: {
                    "source/static/css/app.min.css": [
                        "source/static/css/bootstrap.min.css", "source/static/css/typicons.css",
                        "source/static/css/app.css"
                    ],
                    "source/static/css/admin.min.css": [
                        "source/static/css/bootstrap.min.css", "source/static/css/bootstrap-responsive.min.css",
                        "source/static/css/admin.css"
                    ]
                }
            }
        },
        dotjs: {
            options: {},
            files: {
                "source/static/js/template.js": ['source/views/partials/gamePage.dot']
            }
        },
        coffee : {
            compile: {
                files : {
                    'source/static/js/app.body.js':["source/client/models/*.coffee", "source/client/collections/*.coffee",
                        "source/client/views/**/**.coffee", "source/client/app.coffee"
                    ],
                    'source/static/js/admin.body.js':["source/client/admin.coffee"]
                },
                options: {
                    bare: true
                }
            }
        },
        uglify : {
            head: {
                files : {
                    "source/static/js/app.head.js" :[
                        "source/static/js/jquery-1.9.1.min.js", "source/static/js/jquery.cookie.js",
                        "source/static/js/underscore.js", "source/static/js/backbone.js",
                        "source/static/js/infiniScroll.js", "source/static/js/dot.min.js",
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
        }
    });


    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-dotjs');

    grunt.registerTask('default', ['less', 'cssmin', 'uglify', 'coffee', 'dotjs']);
    //grunt.registerTask('default', 'dotjs');

};


