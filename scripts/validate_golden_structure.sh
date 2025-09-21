#!/usr/bin/env bash

if find goldens/ -type f ! -name "*.png" | grep .; then
  echo "❌ goldens/ direktorijā drīkst būt tikai .png faili!"
  exit 1
fi

echo "✅ goldens/ struktūra ir korekta."
