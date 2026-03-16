#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="${ROOT_DIR}/.venv"
PYINSTALLER_CONFIG_DIR="${ROOT_DIR}/.pyinstaller"

if [[ ! -d "${VENV_DIR}" ]]; then
  python3 -m venv "${VENV_DIR}"
fi

source "${VENV_DIR}/bin/activate"

export PYINSTALLER_CONFIG_DIR

if [[ ! -x "${VENV_DIR}/bin/pyinstaller" ]]; then
  python -m pip install --upgrade pip wheel setuptools
  python -m pip install -r "${ROOT_DIR}/requirements.txt" pyinstaller
fi

pyinstaller \
  --noconfirm \
  --windowed \
  --name GeoPort \
  --recursive-copy-metadata pymobiledevice3 \
  --add-data "${ROOT_DIR}/src/templates:templates" \
  "${ROOT_DIR}/src/main.py"

echo "Build complete: ${ROOT_DIR}/dist/GeoPort.app"
