cmake_minimum_required(VERSION 3.16)
project(hello VERSION 0.1.0 LANGUAGES C CXX)

set(SRC_FILES  
        src/libgpiod-led.c         
        src/libgpiod-input.c 
) 
add_executable(lab3 ${SRC_FILES}) 

install(TARGETS lab3
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/local/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/arm-linux-gnueabihf/)
target_link_libraries(lab3 /var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/lib/arm-linux-gnueabihf/libgpiod.so)