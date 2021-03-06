FROM lsiobase/ubuntu:bionic
MAINTAINER saarg

# package version
#ARG ARGTABLE_VER="2.13"
#ARG UNICODE_VER="2.09"
#ARG XMLTV_VER="0.5.68"
ARG TVH_VER="master"
ARG TVHEADEND_COMMIT


# Environment settings
ENV HOME="/config"
ARG DEBIAN_FRONTEND="noninteractive"

# add dependencies
RUN \
 apt-get update && \
 apt-get upgrade -qy && \
 apt-get install -qy --no-install-recommends \
	autoconf \
	automake \
	binutils \
	build-essential \
	bzip2 \
	cmake \
	dvb-apps \
	gettext \
	git \
	gzip \
	jq \
	libavahi-client-dev \
	libdvbcsa-dev \
	libhdhomerun-dev \
	libiconv-hook-dev \
	libssl-dev \
	libtool \
	libva-dev \
	pkg-config \
	python \
	wget \
	zlib1g-dev && \
 echo "**** build tvheadend ****" && \
 if [ -z ${TVHEADEND_COMMIT+x} ]; then \
	TVHEADEND_COMMIT=$(curl -sX GET https://api.github.com/repos/tvheadend/tvheadend/commits/${TVH_VER} \
	| jq -r '. | .sha'); \
 fi && \
 git clone https://github.com/tvheadend/tvheadend.git /tmp/tvheadend && \
 cd /tmp/tvheadend && \
 git checkout ${TVHEADEND_COMMIT} && \
 ./configure \
	`#Encoding` \
	--enable-ffmpeg_static \
	--disable-libav \
	\
	`#Options` \
	--disable-bintray_cache \
	--enable-hdhomerun_static \
	--enable-hdhomerun_client \
	--enable-pngquant \
	--enable-trace \
	--enable-vaapi && \
 make && \
 make install && \
 echo "**** install dependencies for comskip ****" && \
 apt-get install -qy --no-install-recommends \
	libargtable2-dev \
	libavformat-dev \
	libbz2-dev \
	libdca-dev \
	libfaac-dev \
	libfdk-aac-dev \
	libmp3lame-dev \
	libopencore-amrnb-dev \
	libopencore-amrwb-dev \
	libopus-dev \
	libsdl1.2-dev \
	libsoxr-dev \
	libspeex-dev \
	libva-dev \
	libxvidcore-dev \
	libvo-aacenc-dev \
	libvorbisenc2 \
	libvorbis-dev \
	libvpx-dev \
	libx264-dev \
	libx265-dev && \
 echo "**** build comskip ****" && \
 git clone git://github.com/erikkaashoek/Comskip /tmp/comskip && \
 cd /tmp/comskip && \
 ./autogen.sh && \
 ./configure \
	--bindir=/usr/bin \
	--sysconfdir=/config/comskip && \
 make && \
 make install && \
 echo "**** remove build dependencies ****" && \
 apt autoremove && \
 apt-get purge -qy --allow-remove-essential \
	autoconf \
	automake \
	binutils \
	build-essential \
	cmake \
	gettext \
	git \
	libargtable2-dev \
	libavformat-dev \
	libbz2-dev \
	libdca-dev \
	libfaac-dev \
	libfdk-aac-dev \
	libmp3lame-dev \
	libopencore-amrnb-dev \
	libopencore-amrwb-dev \
	libopus-dev \
	libsdl1.2-dev \
	libsoxr-dev \
	libspeex-dev \
	libva-dev \
	libxvidcore-dev \
	libvo-aacenc-dev \
	libvorbisenc2 \
	libvorbis-dev \
	libvpx-dev \
	libx264-dev \
	libx265-dev \
	libavahi-client-dev \
	libhdhomerun-dev \
	libiconv-hook-dev \
	libssl-dev \
	libtool \
	pkg-config \
	python \
	wget \
	zlib1g-dev && \
 echo "**** install runtime dependencies ****" && \
 apt-get install -qy --no-install-recommends \
	libargtable2-0 \
	libavahi-client3 \
	libavahi-common3 \
	libc6 \
	libdbus-1-3 \
	libssl1.0.0 \
	xmltv \
	zlib1g && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# copy local files
COPY root/ /
