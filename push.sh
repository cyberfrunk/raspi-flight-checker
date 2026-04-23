#!/bin/bash

cd /home/pi/flugchecker || exit

cp /home/pi/flug_checker.py .

# Nur weitermachen wenn sich was geändert hat
git diff --quiet && echo "Keine Änderungen" && exit

git add flug_checker.py
git commit -m "auto update $(date '+%Y-%m-%d %H:%M:%S')"
git push

echo "✅ GitHub Update fertig"
