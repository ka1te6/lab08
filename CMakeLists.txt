cmake_minimum_required(VERSION 3.10)

project(lab05)

option(BUILD_TESTS "Build tests" ON)

add_subdirectory(formatter_lib)
add_subdirectory(formatter_ex_lib)
add_subdirectory(hello_world_application)
add_subdirectory(solver_lib)
add_subdirectory(solver_application)

install(TARGETS hello_world solver DESTINATION bin)
install(TARGETS formatter formatter_ex solver_lib DESTINATION lib)

if(BUILD_TESTS)
  enable_testing()

  include(FetchContent)
  FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/release-1.12.1.zip
  )
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  FetchContent_MakeAvailable(googletest)

  file(GLOB TEST_SOURCES tests/*.cpp)
  add_executable(check ${TEST_SOURCES})
  target_link_libraries(check
    formatter
    formatter_ex
    solver_lib
    gtest_main
  )
  add_test(NAME check COMMAND check)
endif()

include(CPackConfig.cmake)
