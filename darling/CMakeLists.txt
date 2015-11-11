project(libobjc-apple)

cmake_minimum_required(VERSION 2.4.0)
if(COMMAND cmake_policy)
	cmake_policy(SET CMP0003 NEW)
endif(COMMAND cmake_policy)

#if (NOT "${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ARG1}" MATCHES ".*clang")
#	message(FATAL_ERROR "Clang is the only supported compiler.")
#endif (NOT "${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ARG1}" MATCHES ".*clang")

if (BITS EQUAL 64) # Would need to be extended for ARM
	set(OBJC_ABI_2 TRUE)
	add_definitions(-DOBJC_ABI_2=1)
	message(STATUS "Building ObjC ABI 2")
endif(BITS EQUAL 64)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_definitions(-D__STDC_LIMIT_MACROS)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fPIC -fvisibility=hidden -fconstant-string-class=NSConstantString -ggdb -nostdinc -nostdinc++")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -fPIC -fvisibility=hidden -ggdb")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fPIC")

include_directories(${DARLING_TOP_DIRECTORY}/src/external/libcxx/include)
include_directories(${DARLING_TOP_DIRECTORY}/src)
#include_directories(${DARLING_TOP_DIRECTORY}/platform-include)
include_directories(${DARLING_TOP_DIRECTORY}/src/libc/include)
include_directories(${DARLING_TOP_DIRECTORY}/src/libc/include/FreeBSD)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/..)

set(objcdarwin_SRCS
	i386/objc_msgSend.S
	i386/objc_msgSendSuper.S

	x86-64/objc_msgSend_fixup.S
	x86-64/objc_msgSend.S
	x86-64/objc_msgSendSuper.S

	ClassRegister.cpp
	#TrampolineHelper.mm
	
	common/attribute.cpp
	common/property.cpp
	common/selector.cpp
	common/cfstring.cpp
	dso_handle.c
	../../../util/debug.cpp
	
	# These two should go into Foundation
	#NSDarwinFramework.mm
	#misc.mm
)

if(NOT OBJC_ABI_2)
	set(objcdarwin_SRCS
		${objcdarwin_SRCS}
		
		old/exceptions.cpp
		old/category.cpp
		old/class.cpp
		old/ivar.mm
		old/protocol.cpp
	)
else(NOT OBJC_ABI_2)
	set(objcdarwin_SRCS
		${objcdarwin_SRCS}
		
		new/exceptions.cpp
		new/category.cpp
		new/class.cpp
		new/ivar.cpp
		new/protocol.cpp
		
		new/return.S
	)
endif(NOT OBJC_ABI_2)

add_library(objc-apple OBJECT ${objcdarwin_SRCS})


