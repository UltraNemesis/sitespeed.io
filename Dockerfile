FROM sitespeedio/webbrowsers:firefox-54.0-chrome-60.0

ENV SITESPEED_IO_BROWSERTIME__XVFB true
ENV SITESPEED_IO_BROWSERTIME__CHROME__ARGS no-sandbox

RUN addgroup --system --gid 2718 ppoker && \
    adduser --system --uid 2718 --gid 2718 --home /usr/src/ppoker ppoker
    
RUN usermod -aG sudo ppoker

USER ppoker

#RUN mkdir -p /usr/src/ppoker
WORKDIR /usr/src/ppoker


COPY package.json /usr/src/ppoker/
RUN npm install --production
COPY . /usr/src/ppoker

COPY docker/scripts/start.sh /start.sh

## This is to avoid click the OK button
RUN mkdir -m 0750 /root/.android
ADD docker/adb/insecure_shared_adbkey /root/.android/adbkey
ADD docker/adb/insecure_shared_adbkey.pub /root/.android/adbkey.pub

ENTRYPOINT ["/start.sh"]
VOLUME /sitespeed.io
WORKDIR /sitespeed.io
