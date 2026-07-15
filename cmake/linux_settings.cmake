# Linux specific settings for Strecs3D

# vcpkgのみを使用するようにパス設定（システムライブラリより優先）
# CMAKE_PREFIX_PATHをvcpkgのインストール先に向ける
set(CMAKE_PREFIX_PATH "${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}" CACHE PATH "" FORCE)

# Linux用のコンパイラフラグ設定
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g")
endif()

# AppImage で再配置可能になるよう RPATH を $ORIGIN ベースに設定
set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)
set(CMAKE_INSTALL_RPATH "$ORIGIN;$ORIGIN/../lib;${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib")
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH ON)

# Linux用の設定を適用する関数
function(apply_linux_settings TARGET_NAME)
  # OpenCASCADEのインクルードディレクトリを追加
  target_include_directories(${TARGET_NAME} PRIVATE ${OpenCASCADE_INCLUDE_DIR})

  # Linux用のリンクライブラリ設定（vcpkgから取得したライブラリを使用）
  target_link_libraries(${TARGET_NAME} PRIVATE
    Qt6::Core
    Qt6::Widgets
    Qt6::Network
    ${VTK_LIBRARIES}
    lib3mf::lib3mf
    libzip::zip
    pugixml::pugixml
    $<IF:$<TARGET_EXISTS:gmsh::shared>,gmsh::shared,gmsh::lib>
    ${OpenCASCADE_LIBRARIES}
    nlohmann_json::nlohmann_json
  )

  # Add Linux specific source files
  target_sources(${TARGET_NAME} PRIVATE "${CMAKE_SOURCE_DIR}/UI/platform/linux/WindowUtils.cpp")

  set_target_properties(${TARGET_NAME} PROPERTIES
    BUILD_WITH_INSTALL_RPATH TRUE
    INSTALL_RPATH_USE_LINK_PATH TRUE
  )
endfunction()

# Qtプラグインパスを設定（vcpkgのQtを使用）
if(Qt6_DIR)
  get_filename_component(QT_INSTALL_PREFIX "${Qt6_DIR}/../../../" ABSOLUTE)
  set(QT_PLUGIN_PATH "${QT_INSTALL_PREFIX}/plugins")
  if(EXISTS "${QT_PLUGIN_PATH}")
    message(STATUS "Found Qt plugins at: ${QT_PLUGIN_PATH}")
  else()
    message(WARNING "Qt plugins not found at ${QT_PLUGIN_PATH}")
  endif()
else()
  message(WARNING "Qt6_DIR not set. Please ensure Qt6 is installed via vcpkg.")
endif()
