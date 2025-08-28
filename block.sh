#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Starting BlockAssist smart installer..."

# === Variables ===
REPO_URL="https://github.com/gensyn-ai/blockassist.git"
REPO_DIR="$HOME/blockassist"
PYTHON_VERSION="3.10.14"

# === Clone repo ===
if [ -d "$REPO_DIR" ]; then
  echo "📂 Repo already exists at $REPO_DIR → pulling latest changes..."
  cd "$REPO_DIR"
  git pull --rebase
else
  echo "📥 Cloning BlockAssist..."
  git clone "$REPO_URL" "$REPO_DIR"
  cd "$REPO_DIR"
fi

# === Run setup.sh if present ===
if [ -x ./setup.sh ]; then
  echo "⚙️ Running project setup.sh ..."
  ./setup.sh || echo "⚠️ setup.sh failed or skipped, continuing..."
fi

# === Install pyenv if missing ===
if ! command -v pyenv >/dev/null 2>&1; then
  echo "📦 Installing pyenv..."
  curl -fsSL https://pyenv.run | bash
fi

# === Configure pyenv in shell ===
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Persist to ~/.bashrc if not already present
grep -q 'PYENV_ROOT' ~/.bashrc || {
cat >> ~/.bashrc <<'EOF'
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF
}

# === Install Python ===
if ! pyenv versions --bare | grep -q "$PYTHON_VERSION"; then
  echo "🐍 Installing Python $PYTHON_VERSION ..."
  sudo apt update -y
  sudo apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev \
    xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
  pyenv install "$PYTHON_VERSION"
fi

# Use local version
pyenv local "$PYTHON_VERSION"

# === Pip deps ===
echo "📦 Installing Python packages..."
python -m pip install --upgrade pip
pip install -U psutil readchar huggingface_hub

# === cuDNN install ===
CUDNN_DEB="cudnn-local-repo-ubuntu2204-9.11.0_1.0-1_amd64.deb"
if ! ldconfig -p | grep -q libcudnn; then
  echo "🎮 Installing cuDNN..."
  if [ ! -f "$CUDNN_DEB" ]; then
    wget -q https://developer.download.nvidia.com/compute/cudnn/9.11.0/local_installers/$CUDNN_DEB
  fi
  sudo dpkg -i "$CUDNN_DEB" || true
  sudo cp /var/cudnn-local-repo-ubuntu2204-9.11.0/cudnn-local-*.gpg /usr/share/keyrings/ || true
  echo "deb [signed-by=/usr/share/keyrings/cudnn-local-4EC753EA-keyring.gpg] file:///var/cudnn-local-repo-ubuntu2204-9.11.0 /" | \
    sudo tee /etc/apt/sources.list.d/cudnn-local.list >/dev/null
  sudo apt update
  sudo apt install -y libcudnn9 libcudnn9-dev
fi

# === CUDA Path ===
if ! grep -q '/usr/local/cuda/lib64' ~/.bashrc; then
  echo "🔧 Adding CUDA lib to PATH..."
  echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
fi
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

echo ""
echo "✅ BlockAssist environment ready."
echo "👉 Next step: run BlockAssist manually:"
echo "cd ~/blockassist && python run.py"

