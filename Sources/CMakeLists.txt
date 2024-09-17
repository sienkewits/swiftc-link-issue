
file(GLOB DUMMY_SOURCES "DummyFiles/*Dummy*.swift")

# Comment this out to make the problem go away
file(GLOB MORE_DUMMY_SOURCES "MoreDummyFiles/468_Dummy44.swift")

add_library(DummyLibrary STATIC
  ${DUMMY_SOURCES}
  ${MORE_DUMMY_SOURCES}
  )
target_link_libraries(DummyLibrary PRIVATE
  )
set_target_properties(DummyLibrary PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})

_install_target(DummyLibrary)
set_property(GLOBAL APPEND PROPERTY SWIFT_COLLECTIONS_EXPORTS DummyLibrary)
