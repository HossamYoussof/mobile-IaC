FROM jenkins/jenkins:lts

USER jenkins
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

COPY casc /var/jenkins_config
ENV CASC_JENKINS_CONFIG /var/jenkins_config
