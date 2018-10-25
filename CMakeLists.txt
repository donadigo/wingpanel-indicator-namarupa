# This a sample CMakeLists.txt for compiling indicatos for Wingpanel
# http://elementaryos.org/docs/developer-guide/cmake

cmake_minimum_required (VERSION 2.6)
cmake_policy (VERSION 2.6)

# Set the Title to use for the Indicator (May be used in future features)
set (INDICATORTITLE "Ayatana Compatibility")

# The description of what your Indicator is
set (INDICATORDESCRIPTION "Ayatana Compatibility plugin")

# Projectname
project (ayatana_compatibility)

#########################################################
# Only alter stuff below if you know what you are doing #
#########################################################

# Configuration
include (GNUInstallDirs)
set (DATADIR "${CMAKE_INSTALL_FULL_LIBDIR}/wingpanel")
set (PKGDATADIR "${DATADIR}")
set (INDICATORNAME "${CMAKE_PROJECT_NAME}")
set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}-indicator")
set (VERSION "2.0.3")
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

find_package (PkgConfig)
# Find the Indicator Directory
execute_process (COMMAND ${PKG_CONFIG_EXECUTABLE} indicator3-0.4 --variable=indicatordir OUTPUT_VARIABLE current_indicatordir OUTPUT_STRIP_TRAILING_WHITESPACE)
set (AYANATAINDICATORDIR ${current_indicatordir})
# Configure file
set (CONFIG_FILE ${CMAKE_CURRENT_BINARY_DIR}/config.h)
configure_file (${CMAKE_CURRENT_SOURCE_DIR}/config.h.cmake ${CONFIG_FILE})
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

# Comment this out to enable C compiler warnings
add_definitions (-w)

# Files
file (GLOB resources "${CMAKE_CURRENT_SOURCE_DIR}/data/*")

# Code
add_subdirectory(src)
