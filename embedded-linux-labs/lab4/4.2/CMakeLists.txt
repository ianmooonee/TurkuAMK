cmake_minimum_required(VERSION 3.16)
project(lab4.2 VERSION 0.1.0 LANGUAGES C CXX)

add_executable(lab4.2 main.c timers_init_mod.c)
target_link_libraries(lab4.2 /var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/lib/arm-linux-gnueabihf/librt.so)
target_link_libraries(lab4.2 /var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/lib/arm-linux-gnueabihf/libgpiod.so)
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/local/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/arm-linux-gnueabihf/) 

install(TARGETS lab4.2
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})