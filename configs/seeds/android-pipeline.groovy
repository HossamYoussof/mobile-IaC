// Android CI/CD Pipeline Job Definition
pipelineJob('Android-CI-CD') {
    description('Android CI/CD Pipeline for building, testing, and deploying Android applications')
    
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/HossamYoussof/nowinandroid.git')
                        credentials('github-credentials')
                    }
                    branch('*/Jenkins_ci')
                }
            }
            scriptPath('.jenkins/Build')
        }
    }
    
    triggers {
        scm('H/15 * * * *')
    }
    
    parameters {
        choiceParam('BUILD_TYPE', ['debug', 'release'], 'Build type (debug or release)')
        booleanParam('RUN_TESTS', true, 'Run unit and instrumentation tests')
        booleanParam('STATIC_ANALYSIS', true, 'Run static code analysis with SonarQube')
    }
}

// Create a folder for mobile projects
folder('Mobile-Projects') {
    description('Mobile application projects')
}

// Create a template job for new Android projects
pipelineJob('Mobile-Projects/Android-Template') {
    description('Template for new Android projects - copy this to create a new project pipeline')
    
    definition {
        cps {
            script('''
                pipeline {
                    agent {
                        node {
                            label 'android'
                        }
                    }

                    stages {
                        stage('Checkout') {
                            steps {
                                checkout scmGit(
                                    branches: [[name: 'main']],
                                    userRemoteConfigs: [
                                        [ url: 'https://github.com/android/architecture-samples.git' ]
                                    ]
                                )
                            }
                        }
                    
                        stage('Build') {
                            steps {
                                sh './gradlew clean assembleDebug'
                            }
                        }
                        
                        stage('Test') {
                            steps {
                                sh './gradlew test'
                            }
                            post {
                                always {
                                    junit '**/build/test-results/**/*.xml'
                                }
                            }
                        }
                        
                        stage('Static Analysis') {
                            steps {
                                sh './gradlew sonarqube -Dsonar.host.url=http://localhost:9000'
                            }
                        }
                        
                        stage('Archive') {
                            steps {
                                archiveArtifacts artifacts: '**/build/outputs/apk/debug/*.apk', fingerprint: true
                            }
                        }
                    }
                }
                ''')
            sandbox()
        }
    }
}
