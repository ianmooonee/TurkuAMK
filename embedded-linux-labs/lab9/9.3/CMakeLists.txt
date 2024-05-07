cmake_minimum_required(VERSION 3.16)
project(lab9.3-parser VERSION 0.1.0 LANGUAGES C CXX)

set(SRC_FILES
        parser.c
        yuarel.c
) 
add_executable(lab9.3-parser ${SRC_FILES}) 

install(TARGETS lab9.3-parser
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/local/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/arm-linux-gnueabihf/)
target_link_libraries(lab9.3-parser /var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/lib/arm-linux-gnueabihf/libgpiod.so)