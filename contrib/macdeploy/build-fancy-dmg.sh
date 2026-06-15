#!/bin/bash
# 1. Package the internal Qt frameworks
macdeployqt bitcoin-fast-qt.app

# 2. Build the fancy, stylized layout using the native installer engine
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
