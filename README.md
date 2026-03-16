# GeoPort

GeoPort is a Flask + `pymobiledevice3` app for iPhone location simulation.

This fork is set up for local development and source execution on macOS, with:

- USB spoofing working through a TCP tunnel first
- RSD/QUIC retained as a fallback path
- Australia-focused defaults
- `.env`-controlled local port selection
- a reproducible macOS build script

## Attribution

- Original GeoPort project by `davesc63`
- This fork has been modified with Codex assistance for local maintenance, debugging, and workflow updates

## Current Status

- Tested locally on macOS with an iPhone 11 Pro Max on iOS `26.3`
- USB connection and location spoofing work through the current TCP fallback path
- RSD discovery may still fail on some newer iOS/macOS combinations, so it is not the primary path in this fork

## Repository Layout

- `src/main.py`: backend Flask app and device/tunnel logic
- `src/templates/map.html`: frontend UI
- `requirements.txt`: Python dependencies
- `build_macos.sh`: local PyInstaller build script
- `.env.example`: local environment template

## Requirements

## macOS

- Python 3.11+
- `sudo` access
- iPhone connected by USB for first pairing
- Developer Mode enabled on the device

## Windows

This repository still contains Windows-specific code paths, but this fork has been exercised primarily on macOS.

## Setup

Create the virtual environment and install dependencies:

```zsh
cd "/path/to/GeoPort"
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip wheel setuptools
python -m pip install -r requirements.txt
```

Create your local env file:

```zsh
cp .env.example .env
```

Default `.env`:

```env
GEOPORT_PORT=3000
```

Port priority is:

1. `--port`
2. `GEOPORT_PORT` from `.env`
3. fallback `54321`

## Run From Source

Start GeoPort:

```zsh
cd "/path/to/GeoPort"
source .venv/bin/activate
sudo .venv/bin/python src/main.py --no-browser
```

Then open:

```text
http://localhost:3000
```

If you prefer a different port for one run:

```zsh
sudo .venv/bin/python src/main.py --no-browser --port 54321
```

## UI Defaults In This Fork

- map starts in `Shellharbour NSW, Australia`
- dark mode enabled by default
- fuel mode enabled by default
- searches are Australia-bound
- direct `lat,lng` input is parsed as coordinates instead of being geocoded as a place name

## Logs

GeoPort writes logs to:

```text
GeoPort.log
```

Useful command while testing:

```zsh
tail -n 200 GeoPort.log
```

## Typical Test Flow

1. Connect the iPhone by USB
2. Unlock the phone
3. Confirm Developer Mode is enabled
4. Open GeoPort in the browser
5. Click `Connect`
6. Pick a location on the map
7. Click `Simulate Location`
8. Verify the phone location changed
9. Click `Stop Location`

Frontend behavior in this fork:

- `Stop Location` stays disabled until a spoof is active
- after moving the marker again, the left button changes from `Simulate Location` to `Update Location`

## Build macOS App

Build the bundled app with PyInstaller:

```zsh
./build_macos.sh
```

Output:

```text
dist/GeoPort.app
```

Run the built app binary directly:

```zsh
sudo dist/GeoPort.app/Contents/MacOS/GeoPort --no-browser
```

## Tunnel Behavior

For modern iOS in this fork:

- USB TCP tunnel is attempted first
- RSD/QUIC is used as fallback

This is intentional. On the tested iOS `26.3` setup, RSD discovery reported `No devices found` while the TCP path still connected and spoofed successfully.

## Troubleshooting

## `Connect` spins or fails

- check `GeoPort.log`
- make sure the phone is unlocked
- make sure the process is running with `sudo`
- reconnect the USB cable
- verify Developer Mode is enabled on the phone

## `No devices found` appears in logs

If spoofing still succeeds afterward, that may only mean the RSD path failed and TCP fallback succeeded. Check the log for:

```text
Attempting TCP tunnel for USB connection
TCP Address:
TCP Port:
Location Set Successfully
```

## Location lands in the wrong place

Use a plain coordinate string:

```text
-33.88321, 151.22051
```

This fork parses numeric coordinates directly before geocoding.

## Disconnect / refresh state looks wrong

The frontend now restores connection state from the backend and releases active connections on disconnect. If behavior looks stale, refresh once and inspect `GeoPort.log`.

## Notes

- This fork is focused on practical local execution rather than mirroring upstream release packaging/docs.
- The upstream README/release information is no longer the source of truth for this fork’s behavior.
