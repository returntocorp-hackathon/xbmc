#! /bin/sh

# Applied Cyber Hackathon Scan-Build Wrapper Script
# =================================================
# This script runs tools which configure the project to build on your machine.
# It then runs a custom version of scan-build; scan-build runs static analysis
# on the code as it complies. The output is saved to a log file in this working
# directory, each scan's log file is indexed by the datetime that the scan was
# started.

make -C tools/depends/target/libfmt PREFIX=/usr/local
export CMAKE_PREFIX_PATH=/usr/bin/fmt
export CMAKE_PREFIX_PATH=FMT
make -C tools/depends/target/crossguid PREFIX=/usr/local
make -C tools/depends/target/wayland-protocols PREFIX=/usr/local
make -C tools/depends/target/waylandpp PREFIX=/usr/local
mkdir builddir
cd builddir
# cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DCORE_PLATFORM_NAME=wayland -DWAYLAND_RENDER_SYSTEM=gl
cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local
# cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DENABLE_INTERNAL_FMT=ON -DENABLE_INTERNAL_CROSSGUID=ON -DENABLE_INTERNAL_RapidJSON=ON
datetime_startrun=$(date +"%Y%m%d%H%M%S")

# Please note that scan-build has many interesting flags to run deeper analysis
# of programs. These flags are not enabled by default, so participants are
# encouraged to run `scan-build -h` and look through what the tool has to
# offer. You can enable these flags by editing the line below.
scan-build --use-c++=/usr/bin/cmake -o /vagrant_data/scan cmake --build . -- VERBOSE=1 2>&1 | tee -a "${datetime_startrun}_scan.log"
