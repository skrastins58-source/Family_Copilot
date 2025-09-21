#!/usr/bin/env bash

if find goldens/ -type f ! -name "*.png" ! -name "README.md" | grep .; then
  echo "❌ goldens/ direktorijā drīkst būt tikai .png faili un README.md!"
  exit 1
fi

echo "✅ goldens/ struktūra ir korekta."
