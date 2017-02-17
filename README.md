docker run -v /home/jpf/Dokumente/d/docker2-share:/home/build/share -it jpf/builder /bin/bash

export PATH=$PATH:/home/build/share/build_tools

setup_host_toolchains

build_gdc_toolchains 6 gdc-6
