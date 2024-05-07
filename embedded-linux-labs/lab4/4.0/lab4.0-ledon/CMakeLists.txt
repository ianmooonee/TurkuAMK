cmake_minimum_required(VERSION 3.16)
project(lab4.0 VERSION 0.1.0 LANGUAGES C CXX)

set(SRC_FILES  
        src/lab4-ledon.c         
) 
add_executable(lab4.0-ledon ${SRC_FILES}) 

install(TARGETS lab4.0-ledon
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/local/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/arm-linux-gnueabihf/)
target_link_libraries(lab4.0-ledon /var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/lib/arm-linux-gnueabihf/libgpiod.so)