from debian:stable

ENV NAME SteamOS
ENV RELEASE brewmaster
ENV URL http://repo.steampowered.com/download/brewmaster/2.195/SteamOSDVD.iso
ENV CHECKSUM 1622cce5703e079218e7dea4bbe796c4
ENV VERSION 2.195

# Install dependencies
RUN apt-get update && \
 DEBIAN_FRONTEND=noninteractive \
 apt-get install -y wget p7zip-full debootstrap fakeroot fakechroot

# Download and extract the SteamOS ISO and clean up
RUN echo $CHECKSUM $NAME.iso > checksum  && wget -O $NAME.iso $URL && md5sum -c checksum && 7z x $NAME.iso -o$NAME && rm -rf $NAME/\[BOOT\] && rm $NAME.iso checksum

RUN mkdir output
COPY build.sh build.sh
COPY brewmaster brewmaster
CMD ./build.sh $RELEASE $NAME output
