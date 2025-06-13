# Copyright 2018 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# cmake build file for C++ route_guide example.
# Assumes protobuf and gRPC have been installed using cmake.
# See cmake_externalproject/CMakeLists.txt for all-in-one cmake build
# that automatically builds all the dependencies before building route_guide.

cmake_minimum_required(VERSION 3.10)

set (CMAKE_CXX_STANDARD 11)

find_package(Threads REQUIRED)
# Find Protobuf installation
find_package(Protobuf REQUIRED)
message(STATUS "Using protobuf ${Protobuf_VERSION}")

set(_PROTOBUF_LIBPROTOBUF protobuf::libprotobuf)
if(CMAKE_CROSSCOMPILING)
  find_program(_PROTOBUF_PROTOC protoc)
else()
  set(_PROTOBUF_PROTOC protobuf::protoc)
endif()

# Find gRPC installation
# For Ubuntu 22.04, use pkg-config to find gRPC
find_package(PkgConfig REQUIRED)
pkg_check_modules(GRPC REQUIRED grpc++)
pkg_check_modules(GRPC_CPP REQUIRED grpc++)
  
message(STATUS "Using gRPC from pkg-config")

# For system-installed gRPC, we need to find the libraries manually
find_library(GRPC_GRPCPP_LIBRARY NAMES grpc++ REQUIRED)
find_library(GRPC_REFLECTION_LIBRARY NAMES grpc++_reflection REQUIRED)
  
set(_GRPC_GRPCPP ${GRPC_GRPCPP_LIBRARY})
set(_REFLECTION ${GRPC_REFLECTION_LIBRARY})
  
find_program(_GRPC_CPP_PLUGIN_EXECUTABLE grpc_cpp_plugin)
if(NOT _GRPC_CPP_PLUGIN_EXECUTABLE)
  message(FATAL_ERROR "grpc_cpp_plugin not found")
endif()
