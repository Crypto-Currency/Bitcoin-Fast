#!/bin/bash
# Package the internal Qt frameworks
macdeployqt bitcoin-fast-qt.app

# Forcefully pull down ALL core boost components to the local target
FRAMEWORKS="./bitcoin-fast-qt.app/Contents/Frameworks"
cp /usr/local/opt/boost/lib/libboost_atomic.dylib "$FRAMEWORKS/"
cp /usr/local/opt/boost/lib/libboost_container.dylib "$FRAMEWORKS/"
cp /usr/local/opt/boost/lib/libboost_chrono.dylib "$FRAMEWORKS/"
cp /usr/local/opt/boost/lib/libboost_date_time.dylib "$FRAMEWORKS/"

# Grant system modifications permissions to unlock the binaries
chmod 755 "$FRAMEWORKS"/libboost_*.dylib

# Rewrite the Internal Global ID headers of the helper dylibs themselves
install_name_tool -id @loader_path/libboost_atomic.dylib "$FRAMEWORKS/libboost_atomic.dylib"
install_name_tool -id @loader_path/libboost_container.dylib "$FRAMEWORKS/libboost_container.dylib"
install_name_tool -id @loader_path/libboost_chrono.dylib "$FRAMEWORKS/libboost_chrono.dylib"
install_name_tool -id @loader_path/libboost_date_time.dylib "$FRAMEWORKS/libboost_date_time.dylib"


# Route the primary libraries to find their helpers next to them inside the bundle
install_name_tool -change /usr/local/opt/boost/lib/libboost_atomic.dylib @loader_path/libboost_atomic.dylib "$FRAMEWORKS/libboost_filesystem.dylib"
install_name_tool -change /usr/local/opt/boost/lib/libboost_atomic.dylib @loader_path/libboost_atomic.dylib "$FRAMEWORKS/libboost_thread.dylib"
install_name_tool -change /usr/local/opt/boost/lib/libboost_container.dylib @loader_path/libboost_container.dylib "$FRAMEWORKS/libboost_program_options.dylib"
install_name_tool -change /usr/local/opt/boost/lib/libboost_chrono.dylib @loader_path/libboost_chrono.dylib "$FRAMEWORKS/libboost_thread.dylib"
install_name_tool -change /usr/local/opt/boost/lib/libboost_date_time.dylib @loader_path/libboost_date_time.dylib "$FRAMEWORKS/libboost_thread.dylib"


# Build the fancy, stylized layout using the native installer engine
create-dmg \
  --volname "Bitcoin-Fast Installer" \
  --background "./contrib/macdeploy/background.png" \
  --window-pos 200 120 \
  --window-size 500 340 \
  --icon-size 110 \
  --icon "bitcoin-fast-qt.app" 115 155 \
  --app-drop-link 385 155 \
  "bitcoin-fast-qt.dmg" \
  "./bitcoin-fast-qt.app"
