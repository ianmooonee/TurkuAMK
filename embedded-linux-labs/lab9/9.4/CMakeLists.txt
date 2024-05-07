cmake_minimum_required(VERSION 3.16)
project(lab9.4 VERSION 0.1.0 LANGUAGES C CXX)

set(SRC_FILES
        time.c
) 
add_executable(lab9.4 ${SRC_FILES}) 

install(TARGETS lab9.4
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/local/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/arm-linux-gnueabihf/)
target_link_libraries(lab9.4 /var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/lib/arm-linux-gnueabihf/libgpiod.so)