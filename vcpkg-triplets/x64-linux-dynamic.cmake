# Overlay of the community "x64-linux-dynamic" triplet.
# Identical to vcpkg's built-in one, plus -fpermissive: OpenCASCADE 7.x's
# StdPrs_BRepFont.cxx assigns FreeType's `unsigned char* tags` to a
# `const char*`, which GCC rejects as an error tagged [-fpermissive].
# The conversion is benign (byte pointers), so we downgrade it to a warning.
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)

set(VCPKG_CXX_FLAGS "-fpermissive")
set(VCPKG_C_FLAGS "")
