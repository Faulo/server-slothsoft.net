pipeline {
    agent {
        label 'Mörkö'
    }
    options {
        disableConcurrentBuilds()
        disableResume()
        disableRestartFromStage()
    }
    stages {
        stage('Load environment') {
            steps {
                script {
                    withEnvFile {
                        docker.image("faulo/farah:${PHP_VERSION}").inside('-v ${STACK_NAME}_farah-data:${WORKSPACE}/data -v ${STACK_NAME}_farah-app:${WORKSPACE}/.deploy') {
                            stage ('Composer setup') {
                                exec 'composer install --no-interaction --optimize-autoloader --classmap-authoritative'
                                exec 'if [ -e vendor/slothsoft/final-fantasy/.git ]; then composer reinstall slothsoft/final-fantasy --prefer-dist --no-interaction --no-progress --no-autoloader; fi'
                                exec 'test ! -e vendor/slothsoft/final-fantasy/test-files/ff1-us.zip'
                                exec 'composer exec server-clean cache logs'
                            }
                            stage ('Run tests') {
                                catchError(buildResult: 'UNSTABLE', catchInterruptions: false) {
                                    exec 'composer exec phpunit -- --log-junit report.xml'
                                }

                                junit 'report.xml'
                            }
                            stage ('Publish') {
                                if (env.BRANCH_NAME != 'main') {
                                    echo "Skipping publication on branch ${env.BRANCH_NAME}."
                                } else if (currentBuild.currentResult == 'SUCCESS') {
                                    exec 'php .jenkins/publish.php .deploy composer.json composer.lock assets src html'

                                    dir('.deploy') {
                                        exec 'composer install --no-interaction --optimize-autoloader --classmap-authoritative --no-dev'
                                        exec 'if [ -e vendor/slothsoft/final-fantasy/.git ]; then composer reinstall slothsoft/final-fantasy --prefer-dist --no-interaction --no-progress --no-autoloader; fi'
                                        exec 'test ! -e vendor/slothsoft/final-fantasy/test-files/ff1-us.zip'
                                        exec 'composer exec server-clean cache logs'
                                    }
                                } else {
                                    echo "Skipping publication because the build is ${currentBuild.currentResult}."
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
