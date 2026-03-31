#!/usr/bin/env bash
# Preview selected file in Nemo using Sushi
# Uses Python to query Nemo's D-Bus interface

# Check if Nemo is focused
WINDOW_CLASS=$(hyprctl activewindow -j 2>/dev/null | grep -oP '"class":\s*"\K[^"]+')

if [[ "$WINDOW_CLASS" != "nemo" ]]; then
    notify-send "Preview" "Nemo is not focused" -u normal
    exit 1
fi

# Use Python to get selected files from Nemo via D-Bus
SELECTED=$(python3 << 'EOF'
import dbus
import urllib.parse
import os

try:
    bus = dbus.SessionBus()
    
    # Get Nemo service
    nemo = bus.get_object('org.Nemo', '/org/Nemo')
    
    # Get all managed objects
    obj_manager = dbus.Interface(nemo, 'org.freedesktop.DBus.ObjectManager')
    objects = obj_manager.GetManagedObjects()
    
    # Look for window slots with selection
    for path, interfaces in objects.items():
        if 'org.Nemo.WindowSlot' in interfaces:
            props = interfaces['org.Nemo.WindowSlot']
            if 'Selection' in props and props['Selection']:
                uris = props['Selection']
                if uris:
                    # Convert first URI to path
                    uri = str(uris[0])
                    if uri.startswith('file://'):
                        path = urllib.parse.unquote(uri[7:])
                        if os.path.isfile(path):
                            print(path)
                            exit(0)
except Exception as e:
    pass

exit(1)
EOF
)

if [[ -n "$SELECTED" && -f "$SELECTED" ]]; then
    sushi "$SELECTED" &
else
    notify-send "Preview" "No file selected" -u normal
fi
