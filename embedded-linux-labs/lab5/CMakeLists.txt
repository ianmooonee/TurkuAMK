cmake_minimum_required(VERSION 3.16)
project(lab5 VERSION 0.1.0 LANGUAGES C CXX)

set(SRC_FILES
        src/main.c
        src/event_test_with_threads_debounce.c         
        src/event_test_with_threads.c
        src/event_test_without_threads.c
) 
add_executable(lab5 ${SRC_FILES}) 

install(TARGETS lab5
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/local/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/) 
include_directories(/var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/include/arm-linux-gnueabihf/)
target_link_libraries(lab5 /var/lib/schroot/chroots/rpi3-bookworm-armhf/usr/lib/arm-linux-gnueabihf/libgpiod.so)
target_link_libraries(lab5 pthread) 