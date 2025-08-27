# 🎮 Gensyn Minecraft BlockAssist on WSL 🛠️

A step-by-step guide to set up **Gensyn Minecraft BlockAssist** in Windows Subsystem for Linux (WSL) with a beautiful, emoji-rich design!

---

## ✅ Prerequisites

- 🪟 **Windows 10/11** with **WSL 2** enabled  
- 🐧 **Ubuntu** (or your favorite Linux distro) in WSL  
- 🐍 **Python 3.10+**  
- 🔧 **Git**  
- 🖼️ **VcXsrv** (or another X server for Windows)  
- 📦 **Poetry** for Python dependency management  

---

## 1️⃣ Install VcXsrv (X Server for Windows) 🖥️

1. [Download VcXsrv](https://sourceforge.net/projects/vcxsrv/)  
    ![VcXsrv Screenshot](https://github.com/HustleAirdrops/Gensyn-Block-Role-Guide/blob/d418a853957c0205d967b244e878cce093e85ee2/Screenshot%202025-08-09%20051036.png)

2. Run the installer and complete the installation.

---

## 2️⃣ Clone & Setup BlockAssist in WSL 🐧

Open your **WSL terminal** and run each command **one by one**:

```bash
git clone https://github.com/gensyn-ai/blockassist.git
cd blockassist
./setup.sh
curl -fsSL https://pyenv.run | bash
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
eval "$(pyenv virtualenv-init -)"
source ~/.bashrc
sudo apt update
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
curl git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
pyenv install 3.10.0
pyenv global 3.10.0
pip install psutil readchar
```

---

## 3️⃣ (Optional) Install cuDNN for Nvidia GPU 🚀

```bash
wget https://developer.download.nvidia.com/compute/cudnn/9.11.0/local_installers/cudnn-local-repo-ubuntu2204-9.11.0_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2204-9.11.0_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-ubuntu2204-9.11.0/cudnn-local-4EC753EA-keyring.gpg /usr/share/keyrings/
echo "deb [signed-by=/usr/share/keyrings/cudnn-local-4EC753EA-keyring.gpg] file:///var/cudnn-local-repo-ubuntu2204-9.11.0 /" | sudo tee /etc/apt/sources.list.d/cudnn-local.list
sudo apt update
sudo apt install -y libcudnn9 libcudnn9-dev
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
```

---

## 4️⃣ Install Poetry (Python Dependency Manager) 📦

```bash
curl -sSL https://install.python-poetry.org | python3 -
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
poetry --version
```

---

## 5️⃣ Configure VcXsrv & X11 for WSL 🖼️

**1.** Open **CMD/PowerShell** and run:

```bash
ipconfig
```
Find your **IPv4 Address** (e.g., `194.138.1.30`).

**2.** Launch **VcXsrv** with these options:
- ✅ Multi-window
- ✅ Start no client
- ✅ Disable access control
- ❌ Uncheck “Native OpenGL”

**3.** In **WSL**:

```bash
sudo apt-get update -y
sudo apt-get install -y x11-apps x11-xserver-utils
export DISPLAY=<WINDOWS_IP>:0
xeyes
xrandr -q
```
- Replace <WINDOWS_IP> with your ip 

**4.** Fix OpenGL issues (software rendering):

```bash
export LIBGL_ALWAYS_SOFTWARE=1
export MESA_LOADER_DRIVER_OVERRIDE=llvmpipe
export LIBGL_ALWAYS_INDIRECT=1
export MESA_GL_VERSION_OVERRIDE=2.1
export _JAVA_OPTIONS='-Xms512m -Xmx2g -Dorg.lwjgl.opengl.Display.allowSoftwareOpenGL=true'
```

---

## 6️⃣ Login to Gensyn Modal & Run BlockAssist 🚦

**1.** Run BlockAssist:
```bash
python run.py
```

**2.** If you get a login error, bypass Gensyn login for local development:
```bash
cd modal-login
yarn dev
```

**3.** Activate Environment & Install BlockAssist Locally (Malmo Fix) 🛠️
```bash
source blockassist-venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
pip install -e .
python - <<'PY'
import pkgutil, sys
print('malmo' in [m.name for m in pkgutil.iter_modules()], 'PYTHONPATH=', sys.path[:3])
PY
#Run these commands inside your WSL Ubuntu:
sudo apt update
sudo apt install -y zip unzip
which zip
zip -v
```

**4.** Open your browser at [http://localhost:3000](http://localhost:3000) and log in to Gensyn.

**5.** After login, press `Ctrl+C` in your terminal and enter `cd`.

**6.** Run BlockAssist again:
```bash
cd ~/blockassist
source blockassist-venv/bin/activate
python3 run.py
```

**7.** When prompted, paste your **Hugging Face token**.

![Hugging Face Token Prompt](https://github.com/HustleAirdrops/Gensyn-Block-Role-Guide/blob/60414bc20fe061df0f35536dd29fc85d0459e285/Screenshot%202025-08-09%20044704.png)

---

## 🎉 You're Done!

Your Minecraft game will open in **VcXsrv**. Enjoy building with **BlockAssist**! 🏗️🧱

---

## 💬 Need Help?

- **Direct Support:** [@Legend_Aashish](https://t.me/Legend_Aashish)
- **Guides & Updates:** [@Hustle_Airdrops](https://t.me/Hustle_Airdrops)

---

> 💡 **Tip:** If you run into issues, double-check your DISPLAY variable and VcXsrv settings!
