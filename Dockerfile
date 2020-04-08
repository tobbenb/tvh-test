FROM lsiobase/ubuntu:bionic
MAINTAINER saarg

# package version
#ARG ARGTABLE_VER="2.13"
#ARG UNICODE_VER="2.09"
#ARG XMLTV_VER="0.5.68"


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

# build tvheadend
 git clone https://github.com/tvheadend/tvheadend.git /tmp/tvheadend && \
 cd /tmp/tvheadend && \
 ./configure \
	`#Encoding` \
	--enable-ffmpeg_static \
	--enable-libfdkaac_static \
	--enable-libtheora_static \
	--enable-libopus_static \
	--enable-libvorbis_static \
	--enable-libvpx_static \
	--enable-libx264_static \
	--enable-libx265_static \
	--enable-libfdkaac \
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

# install dependencies for comskip
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

# build comskip
 git clone git://github.com/erikkaashoek/Comskip /tmp/comskip && \
 cd /tmp/comskip && \
 ./autogen.sh && \
 ./configure \
	--bindir=/usr/bin \
	--sysconfdir=/config/comskip && \
 make -j 4 && \
 make install && \

# remove build dependencies
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

# install runtime dependencies
 apt-get install -qy --no-install-recommends \
	libargtable2-0 \
	libavahi-client3 \
	libavahi-common3 \
	libavformat-ffmpeg56 \
	libc6 \
	libdbus-1-3 \
	libssl1.0.0 \
	xmltv \
	zlib1g && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9981 9982
VOLUME /config /recordings
