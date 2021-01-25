#!groovy

pipeline {

    agent {
        label 'master'
    }

    environment {
        VERSION = "1.${BUILD_NUMBER}-${env.BRANCH_NAME}".replace('/', '-')

        ARTIFACT_NAME = "greeting-api"

        SONAR_URL = "${env.SONAR_URL}"
        SONAR_LOGIN = "${env.SONAR_LOGIN}"
        SONAR_KEY = "${env.SONAR_KEY}"

        GCR_URL = "${env.GCR_URL}"
        DOCKER_IMAGE_NAME = "${GCR_URL}/${ARTIFACT_NAME}:${VERSION}"
    }

    options {
        skipDefaultCheckout()
    }

    stages {
        stage('Assign Maven executor') {
            stages {
                stage('Checkout') {
                    steps {
                        checkout scm
                    }
                }

                stage('Version update') {
                    steps {
                        sh """mvn -f pom.xml clean versions:set -DnewVersion=${VERSION}"""
                    }
                }

                stage('Tests') {
                    parallel {
                        stage('Junit tests') {
                            steps {
                                sh 'mvn -f pom.xml jacoco:instrument test jacoco:restore-instrumented-classes jacoco:report'

                                junit 'target/surefire-reports/*.xml'
                            }
                        }

                        stage('Integration tests') {
                            steps {
                                echo 'Running integration tests'
                            }
                        }
                    }
                }

                stage('Quality gates') {
                    steps {
                        sh """mvn sonar:sonar -Dsonar.projectKey=${SONAR_KEY} -Dsonar.host.url=${
                            SONAR_URL
                        } -Dsonar.login=${SONAR_LOGIN}"""
                    }
                }

                stage('Build artifact') {
                    steps {
                        sh 'mvn -f pom.xml package -Dmaven.test.skip=true'
                    }
                }

                stage('Deploy artifact') {
                    steps {
                        echo "Deploying to Nexus"
                    }
                }

                stage('Build image') {
                    steps {
                        sh """docker build -t ${DOCKER_IMAGE_NAME} ."""
                    }
                }

                stage('Push image') {
                    steps {
                        sh """docker push ${DOCKER_IMAGE_NAME}"""
                    }
                }
            }
        }
    }
}