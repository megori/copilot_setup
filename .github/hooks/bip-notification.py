#!/usr/bin/env python3
"""
Enhanced Bip Notification Hook (Stop Hook)

Plays different bip sounds based on whether an error occurred:
- Normal stop: Short single beep (800Hz, 150ms)
- Timeout error: Longer double beep (600Hz, 200ms x 2)
"""

import json
import sys
import os
import platform
import subprocess

# Timeout patterns to detect (matches any attempt count like "attempt 1/11", "attempt 5/11", etc.)
TIMEOUT_PATTERNS = [
    'Request timed out',
    '[ERROR] API error',
    'API error',
    'timed out',
]

def play_normal_bip():
    """Play a short bip for normal stops"""
    system = platform.system()

    if system == "Windows":
        try:
            subprocess.run([
                "powershell", "-c",
                "[Console]::Beep(800, 150)"
            ], capture_output=True, timeout=1)
        except:
            print("\a", end='', flush=True)
    else:
        print("\a", end='', flush=True)

def play_timeout_bip():
    """Play a longer double bip for timeout errors"""
    system = platform.system()

    if system == "Windows":
        try:
            subprocess.run([
                "powershell", "-c",
                "[Console]::Beep(600, 200); Start-Sleep -Milliseconds 100; [Console]::Beep(600, 200)"
            ], capture_output=True, timeout=2)
        except:
            print("\a\a", end='', flush=True)
    else:
        print("\a\a", end='', flush=True)

def detect_timeout(input_data):
    """Check if the input indicates a timeout error"""
    # Check various fields where the error might appear
    fields_to_check = [
        input_data.get('systemMessage', ''),
        input_data.get('error', ''),
        str(input_data)
    ]

    for field in fields_to_check:
        for pattern in TIMEOUT_PATTERNS:
            if pattern.lower() in str(field).lower():
                return True
    return False

def main():
    # Read hook input (standard pattern for Stop hooks)
    try:
        input_data = json.load(sys.stdin)
    except:
        input_data = {}

    # Detect if this is a timeout error
    is_timeout = detect_timeout(input_data)

    # Play appropriate sound
    if is_timeout:
        play_timeout_bip()
    else:
        play_normal_bip()

    # Always allow workflow to continue
    print(json.dumps({"ok": True}))

if __name__ == "__main__":
    main()
