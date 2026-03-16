#!/bin/bash

VIDEO='/home/ethan/Downloads/horizon-sky-wanderer-moewalls-com.mp4'
FRAME="$HOME/.cache/wal_video_frame.png"

# Force delete old frame so ffmpeg always creates a fresh one
rm -rf "$FRAME"

# Extract frame at 5 seconds for pywal colour generation
ffmpeg -y -i "$VIDEO" -vframes 1 -ss 00:00:05 "$FRAME"

# Verify frame was created
if [ ! -f "$FRAME" ]; then
  echo "ERROR: Failed to extract frame from video"
  exit 1
fi

echo "Frame extracted: $FRAME"

# Generate colours with pywal
wal -i "$FRAME" --backend colorthief --saturate 0.6

# Reload colors for current terminal
cat ~/.cache/wal/sequences

# Kill any existing mpvpaper instance
pkill -x mpvpaper 2>/dev/null
sleep 0.5

# Launch mpvpaper
mpvpaper -o "hwdec=auto profile=fast loop no-audio" eDP-1 "$VIDEO"
