'use strict';
var exec = require('child_process').exec;
var fs = require('fs');

var BUILD_VERSION =  (new Date().getTime()).toString();

module.exports = function(grunt) {

    grunt.package = require('./package.json');
    grunt.build_version = BUILD_VERSION;

    // Project configuration.
    grunt.initConfig({
        version: grunt.package.version,

        git: {
            main: {
                revision: null //this will be set by the git task below
            }
        },

        rpm: {
            main: {
                options: {
                    destination: 'dist/rpm',
                    summary: 'amp cache build',
                    version: '<%= grunt.package.version %>',
                    release: '1',
                    macros: {
                        prefix: '/opt/gg/amp-cache'
                    },
                    postInstall: {src: 'scripts/post-install.sh'},
                    postRemove: {src: 'scripts/post-remove.sh'},
                },
                files: {
                    '/opt/gg/amp-cache': ['run.sh']
                }
            }
        }

    });

    //Register tasks
    grunt.loadNpmTasks('grunt-rpm');

    grunt.registerTask('build', [
        'rpm'
    ]);

    /**
     * Task to read the latest commit hash
     */
    grunt.registerMultiTask('git', 'Git', function() {
        switch (this.target) {
            case 'main':
                // Tell Grunt this task is asynchronous.
                var done = this.async(),
                    that = this,
                    child = exec('git rev-parse --short HEAD', function(error, stdout, stderr) {
                    });

                child.stdout.on('data', function(data) {
                    grunt.config.set("git.main.revision", String(data).trim());
                    done();
                });
                break;
        }
    });
};
