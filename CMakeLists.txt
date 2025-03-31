cmake_minimum_required(VERSION 3.31 FATAL_ERROR)


set(CMAKE_C_COMPILER "clang")
set(CMAKE_CXX_COMPILER "clang++")
set(CMAKE_CXX_STANDARD 17)


set(PROJECT_ROOT_DIR ${CMAKE_SOURCE_DIR})
set(PROJECT_BINARY_DIR ${CMAKE_BINARY_DIR})


list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/chapel")

include(dlcache)
include(CMakePrintHelpers)
find_package(chpl REQUIRED HINTS ${CMAKE_MODULE_PATH})



cmake_print_variables(PROJECT_ROOT_DIR)
cmake_print_variables(PROJECT_BINARY_DIR)
cmake_print_variables(PROJECT_SOURCE_DIR)
# find_package(chpl REQUIRED HINTS ${PROJECT_ROOT_DIR}/cmake/chapel)


project(torchtest LANGUAGES CXX C CHPL)

set(PROJECT_SOURCE_DIR ${PROJECT_ROOT_DIR}/src)
set(PROJECT_LIBRARY_DIR ${PROJECT_ROOT_DIR}/lib)
set(PROJECT_INCLUDE_DIR ${PROJECT_ROOT_DIR}/include)


add_executable(Milk src/Milk.chpl)
# target_include_directories(Milk PRIVATE ${PROJECT_INCLUDE_DIR})
# target_link_libraries(Aloha PRIVATE mylib)




# find_package(chpl REQUIRED HINTS ${PROJECT_ROOT_DIR}/cmake/chapel)
# # project(hello)
# add_executable(hello hello.chpl)








if(UNIX AND NOT APPLE)
    set(LINUX TRUE)
endif()

if(APPLE)
    set(TORCH_DISTRIBUTION "https://download.pytorch.org/libtorch/nightly/cpu/libtorch-macos-arm64-latest.zip")
endif()

if(LINUX)
    set(TORCH_DISTRIBUTION "https://download.pytorch.org/libtorch/nightly/cpu/libtorch-cxx11-abi-static-with-deps-latest.zip")
endif()

include(FetchContent)
FetchContent_Declare(
    libtorch
    URL ${TORCH_DISTRIBUTION}
    )
FetchContent_GetProperties(libtorch)
if(NOT libtorch_POPULATED)
    FetchContent_MakeAvailable(libtorch)
endif()

list(APPEND CMAKE_MODULE_PATH ${libtorch_SOURCE_DIR}/share/cmake)
include_directories(${TORCH_INCLUDE_DIRS})

cmake_print_variables(libtorch_SOURCE_DIR)
cmake_print_variables(libtorch_BINARY_DIR)
cmake_print_variables(libtorch_INCLUDE_DIRS)

cmake_print_variables(libtorch_LIBRARIES)
cmake_print_variables(libtorch_INCLUDE_DIR)
cmake_print_variables(libtorch_LIBRARIES)


cmake_print_variables(TORCH_INCLUDE_DIRS)
cmake_print_variables(TORCH_LIBRARIES)
cmake_print_variables(TORCH_INCLUDE_DIR)

cmake_print_variables(CMAKE_PREFIX_PATH)
cmake_print_variables(CMAKE_MODULE_PATH)
cmake_print_variables(CMAKE_CXX_FLAGS)
# TORCH_CXX_FLAGS
set(PREV_CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH})
set(CMAKE_PREFIX_PATH ${libtorch_SOURCE_DIR})
# option(BUILD_SHARED_LIBS "Build using shared libraries" OFF)
find_package(Torch REQUIRED)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TORCH_CXX_FLAGS}")
# set(CMAKE_PREFIX_PATH ${PREV_CMAKE_PREFIX_PATH})
cmake_print_variables(CMAKE_CXX_FLAGS)
cmake_print_variables(CMAKE_PREFIX_PATH)
cmake_print_variables(TORCH_INCLUDE_DIRS)
cmake_print_variables(TORCH_LIBRARIES)
cmake_print_variables(TORCH_CXX_FLAGS)

# find_library(TORCH_LIBRARIES NAMES torch PATHS ${libtorch_SOURCE_DIR}/lib)


add_executable(${PROJECT_NAME} ${PROJECT_SOURCE_DIR}/main.cpp)
target_link_libraries(${PROJECT_NAME} ${TORCH_LIBRARIES})
# target_link_libraries(${PROJECT_NAME} STATIC torch)

# add_library(torch2 STATIC IMPORTED)
# set_target_properties(torch2 PROPERTIES IMPORTED_LOCATION ${libtorch_SOURCE_DIR}/lib)
# set_target_properties(torch2 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${libtorch_SOURCE_DIR}/lib/include)


# set(TORCH_BRIDGE_TARGETS ${PROJECT_SOURCE_DIR})
# set(TORCH_BRIDGE_INCLUDES ${PROJECT_SOURCE_DIR})
file(GLOB_RECURSE TORCH_BRIDGE_TARGETS "${PROJECT_LIBRARY_DIR}/*.cpp")
file(GLOB_RECURSE TORCH_BRIDGE_INCLUDES "${PROJECT_INCLUDE_DIR}/*.h")

include_directories(${PROJECT_INCLUDE_DIR})
include_directories(${PROJECT_LIBRARY_DIR})

# Add source files
add_library(torchbridge STATIC ${TORCH_BRIDGE_TARGETS})
target_sources(torchbridge PUBLIC ${TORCH_BRIDGE_INCLUDES})
# target_include_directories(torchbridge PUBLIC ${PROJECT_INCLUDE_DIR})

# if(APPLE)
#     set_target_properties(torchbridge PROPERTIES
#         LINK_FLAGS "-Wl,-all_load"
#     )
# else()
#     set_target_properties(torchbridge PROPERTIES
#         LINK_FLAGS "-Wl,--whole-archive,-Wl,--export-all-symbols"
#     )
# endif()

# target_link_libraries(torchbridge STATIC ${TORCH_LIBRARIES})
target_link_libraries(torchbridge STATIC torch)
# target_link_libraries(torchbridge Torch)

set_target_properties(torchbridge PROPERTIES
    PUBLIC_HEADER "${TORCH_BRIDGE_INCLUDES}"
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
    )
include(GNUInstallDirs)

install(
    TARGETS torchbridge 
    EXPORT torchbridge_targets
    LIBRARY DESTINATION ${PROJECT_BINARY_DIR}
    ARCHIVE DESTINATION ${PROJECT_BINARY_DIR}
    PUBLIC_HEADER DESTINATION ${PROJECT_BINARY_DIR} # No idea what this does
    # FILE_SET include
    )



# add_library(torchbridge2 STATIC ${TORCH_BRIDGE_TARGETS})

# target_link_libraries(torchbridge2 torch2)
# install(TARGETS torchbridge2 DESTINATION ${PROJECT_BINARY_DIR})
    

cmake_print_variables(PROJECT_BINARY_DIR)

add_library(mylib OBJECT ${PROJECT_LIBRARY_DIR}/mylib.c ${PROJECT_INCLUDE_DIR}/mylib.h)

file(GLOB_RECURSE CXX_SOURCE_FILES "${PROJECT_LIBRARY_DIR}/*.{c,cpp}")
file(GLOB_RECURSE CXX_HEADER_FILES "${PROJECT_INCLUDE_DIR}/*.{h,hpp}")
file(GLOB_RECURSE CHPL_SOURCE_FILES "${PROJECT_SOURCE_DIR}/*.chpl")

add_custom_command(
    TARGET torchbridge
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${PROJECT_INCLUDE_DIR}
        ${PROJECT_BINARY_DIR}
    )
add_custom_command(
    TARGET torchbridge
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy
        ${CHPL_SOURCE_FILES}
        ${PROJECT_BINARY_DIR}
    )

add_custom_target(
    copy_include_header_files
    ALL
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${PROJECT_INCLUDE_DIR}
        ${PROJECT_BINARY_DIR}
    COMMENT "Copying include files to binary directory"
)

add_custom_target(
    copy_chapel_src_files
    ALL
    COMMAND ${CMAKE_COMMAND} -E copy
        ${CHPL_SOURCE_FILES}
        ${PROJECT_BINARY_DIR}
    COMMENT "Copying Chapel files to binary directory"
)

# add_executable(Aloha ${PROJECT_SOURCE_DIR}/hello.chpl)
# target_include_directories(Aloha PRIVATE ${PROJECT_INCLUDE_DIR})
# target_link_libraries(Aloha PRIVATE mylib)




# add_custom_command(
#     TARGET mylib
#     POST_BUILD
#     COMMAND chpl mylib.h -lmylib myWrapper.chpl
#     )


# add_custom_target(mylib_headers ALL DEPENDS ${CXX_HEADER_FILES})
# add_custom_target(mylib_sources ALL DEPENDS ${CXX_SOURCE_FILES})
# add_custom_target(mylib_chpl ALL DEPENDS ${CHPL_SOURCE_FILES})
# add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/input.txt
#                     COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/input.txt
#                                                     ${CMAKE_CURRENT_BINARY_DIR}/input.txt
#                     DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/input.txt)
# add_custom_command(
#     TARGET mylib
#     PRE_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_directory
#         ${PROJECT_INCLUDE_DIR}
#         ${PROJECT_BINARY_DIR}
#     )
# add_custom_command(
#     TARGET mylib
#     POST_BUILD
#     COMMAND chpl ${CXX_HEADER_FILES} -lmylib myWrapper.chpl
#     )


# configure_file(
#     ${PROJECT_SOURCE_DIR}/mylib.h
#     ${PROJECT_BINARY_DIR}/mylib.h
#     COPYONLY
# )
# target_sources(mylib STATIC ${PROJECT_INCLUDE_DIR}/mylib.h)
# target_link_libraries(torchbridge STATIC ${TORCH_LIBRARIES})

# include(GNUInstallDirs)

# install(
#     TARGETS mylib 
#     EXPORT mylib_targets
#     LIBRARY DESTINATION lib
#     ARCHIVE DESTINATION lib
#     PUBLIC_HEADER DESTINATION include # No idea what this does
#     # FILE_SET include
#     )


# Add include directories
# target_include_directories(torchbridge PUBLIC ${TORCH_BRIDGE_INCLUDES} )

# Add dependencies
# target_link_libraries(torchbridge ${TORCH_LIBRARIES})

# set_target_properties(torchbridge PROPERTIES PUBLIC_HEADER ${TORCH_BRIDGE_INCLUDES})


# install(EXPORT torchbridge_targets
#     FILE torchbridge_config.cmake
#     NAMESPACE torchbridge::
#     DESTINATION lib/cmake/torchbridge
#     )

# install(DIRECTORY include/ DESTINATION include)

#
# target_include_directories(${PROJECT_NAME} PRIVATE ${TORCH_INCLUDE_DIRS})
# target_link_libraries(${PROJECT_NAME} PRIVATE ${TORCH_INCLUDE_DIR})
# set(CMAKE_PREFIX_PATH libtorch_SOURCE_DIR)
#


# add_dependencies(${PROJECT_NAME} ${libtorch_SOURCE_DIR})
# target_link_libraries(${PROJECT_NAME} ${TORCH_LIBRARIES})

# set(CMAKE_PREFIX_PATH libtorch_SOURCE_DIR)

# find_package(Torch REQUIRED)

# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TORCH_CXX_FLAGS}")

# add_executable(${PROJECT_NAME} main.cpp)

# target_link_libraries(${PROJECT_NAME} "${TORCH_LIBRARIES}")

# set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 17)
