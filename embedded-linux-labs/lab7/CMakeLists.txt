cmake_minimum_required(VERSION 3.16)
project(lab7 VERSION 0.1.0 LANGUAGES C CXX)

set(SRC_FILES  
        mqtt-raspi/mqtt-raspi.c  
) 
add_executable(lab7 ${SRC_FILES}) 

install(TARGETS lab7
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/local/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/arm-linux-gnueabihf/)
target_link_libraries(lab7 /var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/lib/arm-linux-gnueabihf/libgpiod.so)
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/local/include/)
target_link_libraries(lab7 /var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/local/lib/libpaho-mqtt3c.so )