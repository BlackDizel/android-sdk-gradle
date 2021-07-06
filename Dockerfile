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

ENV ANDROID_SDK_ROOT "/sdk"

ENV PATH "$PATH:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/"

RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    curl -s https://dl.google.com/android/repository/commandlinetools-linux-${VERSION_SDK_TOOLS}_latest.zip > /sdk.zip && \
    unzip /sdk.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm -v /sdk.zip

ADD packages.txt ${ANDROID_SDK_ROOT}

RUN mkdir -p /root/.android \
  && sdkmanager --update \
  && yes | sdkmanager --package_file=${ANDROID_SDK_ROOT}/packages.txt \
  && yes | sdkmanager --licenses \
  && touch /root/.android/repositories.cfg 

# RUN chmod -R a+rwx ${ANDROID_SDK_ROOT}

