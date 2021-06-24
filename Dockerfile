FROM ubuntu:16.04
MAINTAINER Alexandr Motorin  <alexandrdevmisc@ya.ru>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
      curl \
      html2text \
      openjdk-8-jdk \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32ncurses5 \
      lib32z1 \
      unzip \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RUN rm -f /etc/ssl/certs/java/cacerts; \
#    /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Gradle
ENV SDK_HOME "/opt"
ENV GRADLE_VERSION 6.5
ENV GRADLE_SDK_URL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip

RUN curl -sSL "${GRADLE_SDK_URL}" -o gradle-${GRADLE_VERSION}-bin.zip  \
	&& unzip gradle-${GRADLE_VERSION}-bin.zip -d ${SDK_HOME}  \
	&& rm -rf gradle-${GRADLE_VERSION}-bin.zip
ENV GRADLE_HOME ${SDK_HOME}/gradle-${GRADLE_VERSION}
ENV PATH ${GRADLE_HOME}/bin:$PATH

#Android

ENV VERSION_SDK_TOOLS "7302050"

ENV ANDROID_SDK_ROOT "/sdk/cmdline-tools"
ENV ANDROID_HOME "${ANDROID_SDK_ROOT}/latest"


ENV PATH "$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest"

RUN mkdir -p ${ANDROID_SDK_ROOT} && \
    curl -s https://dl.google.com/android/repository/commandlinetools-linux-${VERSION_SDK_TOOLS}_latest.zip > /sdk.zip && \
    unzip /sdk.zip -d ${ANDROID_SDK_ROOT} && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools ${ANDROID_SDK_ROOT}/latest && \
    rm -v /sdk.zip

# RUN mkdir -p ${ANDROID_SDK_ROOT}/licenses/ \
#  && echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > ${ANDROID_SDK_ROOT}/licenses/android-sdk-license \
#  && echo "84831b9409646a918e30573bab4c9c91346d8abd" > ${ANDROID_SDK_ROOT}/licenses/android-sdk-preview-license

ADD packages.txt ${ANDROID_SDK_ROOT}

RUN mkdir -p /root/.android && \
  touch /root/.android/repositories.cfg && \
  ${ANDROID_SDK_ROOT}/latest/bin/sdkmanager --update && \
  (while [ 1 ]; do sleep 5; echo y; done) | \
  ${ANDROID_SDK_ROOT}/latest/bin/sdkmanager --package_file=\
${ANDROID_SDK_ROOT}/packages.txt

# RUN chmod -R a+rwx ${ANDROID_SDK_ROOT}

