FROM thyrlian/android-sdk:latest

# Install OpenJDK for Swarm client
USER root
RUN apt-get update && apt-get install -y \
    openjdk-11-jre \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create jenkins user and set permissions
RUN useradd -m -d /home/jenkins -s /bin/bash jenkins \
    && mkdir -p /opt/swarm \
    && chown -R jenkins:jenkins /opt/swarm

# Switch to jenkins user
USER jenkins

# Setup swarm client
RUN cd /opt/swarm && \
    curl -fsSL -o swarm-client.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.49/swarm-client-3.49.jar

WORKDIR /projects

ENTRYPOINT ["java", "-jar", "/opt/swarm/swarm-client.jar"]
CMD ["-url", "http://jenkins:8080", "-name", "android-builder", "-labels", "android", "-username", "admin", "-password", "admin", "-executors", "3", "-fsroot", "/projects"]
