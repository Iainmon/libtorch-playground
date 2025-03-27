cmake_minimum_required(VERSION 3.18 FATAL_ERROR)

project(torchtest)
set(CMAKE_CXX_STANDARD 17)

set(PROJECT_ROOT_DIR ${CMAKE_SOURCE_DIR})
set(PROJECT_BINARY_DIR ${CMAKE_BINARY_DIR})

set(PROJECT_SOURCE_DIR ${PROJECT_ROOT_DIR}/src)
set(PROJECT_INCLUDE_DIR ${PROJECT_ROOT_DIR}/include)

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


set(PREV_CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH})
set(CMAKE_PREFIX_PATH ${libtorch_SOURCE_DIR})
find_package(Torch REQUIRED)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TORCH_CXX_FLAGS}")
set(CMAKE_PREFIX_PATH ${PREV_CMAKE_PREFIX_PATH})

add_executable(${PROJECT_NAME} ${PROJECT_SOURCE_DIR}/main.cpp)

target_link_libraries(${PROJECT_NAME} ${TORCH_LIBRARIES})




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
