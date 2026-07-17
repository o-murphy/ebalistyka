#!/bin/bash

# Джерело іконок
ICON_SRC="./macos/Runner/Assets.xcassets/AppIcon.appiconset"

# Цільова директорія
APP_DIR="./app"

# Маппінг розмірів: (назва файлу -> розмір)
declare -A sizes=(
    ["app_icon_16.png"]="16x16"
    ["app_icon_32.png"]="32x32"
    ["app_icon_64.png"]="64x64"
    ["app_icon_128.png"]="128x128"
    ["app_icon_256.png"]="256x256"
    ["app_icon_512.png"]="512x512"
    ["app_icon_1024.png"]="1024x1024"
)

# ID додатку
APP_ID="io.github.o_murphy.ebalistyka"

# Копіюємо кожну іконку
for file in "${!sizes[@]}"; do
    size="${sizes[$file]}"
    src_path="$ICON_SRC/$file"
    
    if [[ -f "$src_path" ]]; then
        dest_dir="$APP_DIR/share/icons/hicolor/$size/apps"
        mkdir -p "$dest_dir"
        cp "$src_path" "$dest_dir/$APP_ID.png"
        echo "✓  скопійовано: $size -> $dest_dir/$APP_ID.png"
    else
        echo "⚠  пропущено: $file (не знайдено)"
    fi
done

echo ""
echo "Готово! Іконки скопійовано в $APP_DIR/share/icons/hicolor/"