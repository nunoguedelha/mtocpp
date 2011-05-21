
IF(NOT RAGEL_EXECUTABLE)
  MESSAGE(STATUS "Looking for ragel")
  FIND_PROGRAM(RAGEL_EXECUTABLE ragel)
  IF(RAGEL_EXECUTABLE)
    EXECUTE_PROCESS(COMMAND "${RAGEL_EXECUTABLE}" -v OUTPUT_VARIABLE _version)
    STRING(REGEX MATCH "[0-9.]+" RAGEL_VERSION ${_version})
    SET(RAGEL_FOUND TRUE)
  ENDIF(RAGEL_EXECUTABLE)
ELSE(NOT RAGEL_EXECUTABLE)
  EXECUTE_PROCESS(COMMAND "${RAGEL_EXECUTABLE}" -v OUTPUT_VARIABLE _version)
  STRING(REGEX MATCH "[0-9.]+" RAGEL_VERSION ${_version})
  SET(RAGEL_FOUND TRUE)
ENDIF(NOT RAGEL_EXECUTABLE)

IF(RAGEL_FOUND)
  IF (NOT Ragel_FIND_QUIETLY)
    MESSAGE(STATUS "Found ragel: ${RAGEL_EXECUTABLE} (${RAGEL_VERSION})")
  ENDIF (NOT Ragel_FIND_QUIETLY)

  IF(NOT RAGEL_FLAGS)
    SET(RAGEL_FLAGS "-T0")
  ENDIF(NOT RAGEL_FLAGS)

  MACRO(RAGEL_PARSER SRCFILE)
    GET_FILENAME_COMPONENT(SRCBASE "${SRCFILE}" NAME_WE)
    SET(OUTFILE "${CMAKE_CURRENT_BINARY_DIR}/${SRCBASE}.cc")
    SET(INFILE "${CMAKE_CURRENT_SOURCE_DIR}/${SRCFILE}.rl")
    ADD_CUSTOM_COMMAND(OUTPUT ${OUTFILE}
      COMMAND "${RAGEL_EXECUTABLE}"
      ARGS -C ${RAGEL_FLAGS} -o "${OUTFILE}" "${INFILE}"
      DEPENDS "${INFILE}"
      COMMENT "Generating ${SRCBASE}.cc from ${SRCFILE}.rl"
    )
  ENDMACRO(RAGEL_PARSER)

ELSE(RAGEL_FOUND)

  IF(Ragel_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find ragel")
  ENDIF(Ragel_FIND_REQUIRED)
ENDIF(RAGEL_FOUND)
