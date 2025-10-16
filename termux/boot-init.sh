#!/data/data/com.termux/files/usr/bin/bash
CONFIG_FILE="$HOME/.termux/config/boot_config.env"
DEFAULT_CONFIG="/data/data/com.termux/files/usr/assets/config/boot_config.env"

# Ensure config exists
if [ ! -f "$CONFIG_FILE" ]; then
  mkdir -p "$HOME/.termux/config"
  cp "$DEFAULT_CONFIG" "$CONFIG_FILE"
fi

source "$CONFIG_FILE"

echo "[*] Updating packages..."
pkg update -y
pkg install -y python nodejs git cronie termux-services

# --- Placeholder backend setup ---
mkdir -p ~/quantum_resistant_bank/backend
cat > ~/quantum_resistant_bank/backend/app.py <<'BACKEND_PLACEHOLDER'
# Placeholder Flask backend
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Backend placeholder is running!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
BACKEND_PLACEHOLDER

# --- Placeholder frontend setup ---
mkdir -p ~/quantum_resistant_bank/frontend
cat > ~/quantum_resistant_bank/frontend/package.json <<'FRONTEND_PLACEHOLDER'
{
  "name": "frontend-placeholder",
  "version": "1.0.0",
  "scripts": {
    "start": "echo 'Frontend placeholder running!'"
  }
}
FRONTEND_PLACEHOLDER

# --- Start Cronie service ---
if [ "$ENABLE_CRONIE" = true ]; then
  echo "[*] Starting Cronie service..."
  crond -b
fi

# --- Smart Flask backend check ---
if [ "$ENABLE_FLASK" = true ]; then
  if pgrep -f "python app.py" > /dev/null; then
    echo "[✓] Flask already running — skipping restart."
  else
    echo "[*] Launching Flask backend..."
    cd ~/quantum_resistant_bank/backend || exit
    nohup python app.py > ~/flask.log 2>&1 &
  fi
fi

# --- Smart Frontend check ---
if [ "$ENABLE_FRONTEND" = true ]; then
  if pgrep -f "npm start" > /dev/null; then
    echo "[✓] Frontend already running — skipping restart."
  else
    echo "[*] Launching Frontend..."
    cd ~/quantum_resistant_bank/frontend || exit
    nohup npm start > ~/frontend.log 2>&1 &
  fi
fi

echo "[✓] Boot initialization completed."
