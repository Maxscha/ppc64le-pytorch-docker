FOR PILLOW
yum install jpeg-dev zlib-dev
yum install     ghostscript     lcms2-devel     libffi-devel     libimagequant-devel     libjpeg-devel     libraqm-devel     libtiff-devel     libwebp-devel
yum install libjpeg-devel

CLONE CHECKOUT
MAX_CONCURRENCY=1 python3 setup.py build_ext  install

RUN yum install freetype-devel ghostscript lcms2-devel libffi-devel libjpeg-devel libtiff-devel libwebp-devel openjpeg2-devel tcl-devel tk-devel xorg-x11-server-Xvfb zlib-devel yum install freetype-devel ghostscript lcms2-devel libffi-devel libjpeg-devel libtiff-devel libwebp-devel openjpeg2-devel tcl-devel tk-devel xorg-x11-server-Xvfb zlib-devel 

RUN CLONE CHECKOUT INSTAL