FROM jenkins/jenkins:latest-jdk21

ARG PLUGINS_FILE=configs/plugins-minimal.txt

USER jenkins
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Copy plugins file directly from the source
COPY ${PLUGINS_FILE} /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

# Copy configuration as code directly
COPY configs/jenkins.yaml /var/jenkins_config/
ENV CASC_JENKINS_CONFIG /var/jenkins_config
