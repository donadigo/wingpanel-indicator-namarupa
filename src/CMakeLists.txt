find_package (PkgConfig)

# Add all your dependencies to the list below
pkg_check_modules (DEPS REQUIRED wingpanel-2.0 granite indicator3-0.4)

add_definitions (${DEPS_CFLAGS})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.24.0" MINIMUM)

include (ValaPrecompile)
# Add all your vala files and requires packages to the List below to include them in the build
vala_precompile (VALA_C ${CMAKE_PROJECT_NAME}
  AyatanaIndicator.vala
  Indicator.vala
  IndicatorFactory.vala
  IndicatorObject.vala
  IndicatorIface.vala
  IndicatorLoader.vala
  IndicatorButton.vala
  SubMenuButton.vala
PACKAGES
  wingpanel-2.0
  granite
  indicator3-0.4
  config
OPTIONS
  --thread
  --vapidir=${CMAKE_SOURCE_DIR}/vapi/
)

include_directories (${CMAKE_BINARY_DIR})
add_library (${CMAKE_PROJECT_NAME} MODULE ${VALA_C})
target_link_libraries(${CMAKE_PROJECT_NAME} ${DEPS_LIBRARIES})

# Installation
install (TARGETS ${CMAKE_PROJECT_NAME} DESTINATION ${PKGDATADIR})
