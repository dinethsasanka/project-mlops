
#!/bin/bash
# ============================================
# MLOps Project Bootstrap Script
# Customer Churn Prediction Platform
# User: mlops
# ============================================
# Usage: bash setup.sh
# ============================================

set -e  # Stop immediately if any command fails

echo "================================================"
echo " MLOps Project Bootstrap Starting..."
echo " User: $(whoami)"
echo " Home: $HOME"
echo "================================================"

# ── VARIABLES ────────────────────────────────────────
MLOPS_DIR="/home/mlops/MLOPS"
VENV_DIR="$MLOPS_DIR/ml-env"
GITHUB_REPO="https://github.com/dinethsasanka/mlops-project.git"

# ── STEP 1: System Update ─────────────────────────────
echo ""
echo "[1/8] Updating system packages..."
sudo apt update -y
sudo apt install -y python3.12-venv python3-pip git curl wget
echo "System packages updated ✅"

# ── STEP 2: Create Project Folder Structure ───────────
echo ""
echo "[2/8] Creating project folder structure..."
mkdir -p $MLOPS_DIR/data/raw
mkdir -p $MLOPS_DIR/data/processed
mkdir -p $MLOPS_DIR/models
mkdir -p $MLOPS_DIR/notebooks
mkdir -p $MLOPS_DIR/scripts
mkdir -p $MLOPS_DIR/config
mkdir -p $MLOPS_DIR/src/data
mkdir -p $MLOPS_DIR/src/features
mkdir -p $MLOPS_DIR/src/models
mkdir -p $MLOPS_DIR/src/utils
mkdir -p $MLOPS_DIR/tests
mkdir -p $MLOPS_DIR/configs
mkdir -p $MLOPS_DIR/docs

# Create __init__.py files so Python treats src/ as a package
touch $MLOPS_DIR/src/__init__.py
touch $MLOPS_DIR/src/data/__init__.py
touch $MLOPS_DIR/src/features/__init__.py
touch $MLOPS_DIR/src/models/__init__.py
touch $MLOPS_DIR/src/utils/__init__.py

echo "Folder structure created ✅"

# ── STEP 3: Virtual Environment (Task 1) ─────────────
echo ""
echo "[3/8] Creating Python virtual environment..."
python3 -m venv $VENV_DIR
echo "Virtual environment created ✅"

# ── STEP 4: Install ML Libraries (Task 1) ────────────
echo ""
echo "[4/8] Installing ML libraries..."
$VENV_DIR/bin/pip install --upgrade pip
$VENV_DIR/bin/pip install numpy pandas scikit-learn matplotlib jupyterlab
echo "ML libraries installed ✅"

# ── STEP 5: Install uv (Task 3) ──────────────────────
echo ""
echo "[5/8] Installing uv package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Source the env file that uv installer creates
# This properly loads uv into the current shell session
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
else
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Verify uv is actually available before continuing
if ! command -v uv &> /dev/null; then
    echo "ERROR: uv installation failed or not found in PATH"
    echo "Trying alternative location..."
    export PATH="$HOME/.local/bin:$PATH"
fi

uv --version
echo "uv installed ✅"

# ── STEP 6: JupyterLab Configuration (Task 2) ────────
echo ""
echo "[6/8] Configuring JupyterLab..."
cat > $MLOPS_DIR/jupyter_lab_config.py << 'JUPYTEREOF'
# Jupyter configuration - Customer Churn MLOps Project
c.ServerApp.token = ''
c.ServerApp.password = ''
c.ServerApp.disable_check_xsrf = True
c.ServerApp.notebook_dir = '/home/mlops/MLOPS/notebooks'
c.ServerApp.port = 8888
c.ServerApp.ip = '0.0.0.0'
JUPYTEREOF
echo "JupyterLab configured ✅"

# ── STEP 7: requirements.in + lockfile (Task 3) ───────
echo ""
echo "[7/8] Creating requirements files..."
cat > $MLOPS_DIR/requirements.in << 'REQEOF'
# Customer Churn MLOps Project - Core Dependencies
scikit-learn
mlflow
pandas
numpy
matplotlib
jupyterlab
REQEOF

# Generate lockfile using uv
# Source again to be safe — PATH must include uv
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
cd $MLOPS_DIR
uv pip compile requirements.in -o requirements.txt

# ── STEP 8: Project Files ─────────────────────────────
echo ""
echo "[8/8] Creating project files..."

# .gitignore
cat > $MLOPS_DIR/.gitignore << 'GITEOF'
ml-env/
mlops-venv/
.ipynb_checkpoints/
githubKey
__pycache__/
*.pyc
.pytest_cache/
*.egg-info/
dist/
.env
GITEOF

# README.md
cat > $MLOPS_DIR/README.md << 'READMEEOF'
# mlops-project

Customer Churn Prediction MLOps Platform built on AWS.

## Project Structure
- `data/`      — Raw and processed datasets
- `models/`    — Trained model artifacts
- `notebooks/` — EDA and exploration notebooks
- `src/`       — Source code package
- `tests/`     — Unit and integration tests
- `configs/`   — Configuration files
- `docs/`      — Project documentation

## Setup
bash setup.sh

## Start JupyterLab
source ml-env/bin/activate
jupyter lab --config=jupyter_lab_config.py --no-browser &
READMEEOF

## Start JupyterLab
source $VENV_DIR/bin/activate
jupyter lab --config=jupyter_lab_config.py --no-browser & > $MLOPS_DIR/jupyter.log 2>&1 & 
echo "Sucessfully started the JUPYTER LAB"

JUPYTER_PID=$!
echo "JupyterLab process started with PID: $JUPYTER_PID"

# Wait 5 seconds for JupyterLab to fully initialize
echo "Waiting for JupyterLab to initialize..."
sleep 5

if ss -tulnp | grep -q ':8888'; then
    echo ""
    echo "✅ JupyterLab started successfully!"
    echo "   PID     : $JUPYTER_PID"
    echo "   Port    : 8888"
    echo "   Access  : http://<your-ec2-public-ip>:8888"
    echo "   Log file: $MLOPS_DIR/jupyter.log"
else
    echo ""
    echo "❌ JupyterLab failed to start!"
    echo "   Check the log file for details:"
    echo "   cat $MLOPS_DIR/jupyter.log"
    echo ""
    echo "Last 20 lines of log:"
    tail -20 $MLOPS_DIR/jupyter.log
    exit 1  # Stop the script with an error
fi


# Fix ownership — everything belongs to mlops user
sudo chown -R mlops:mlops $MLOPS_DIR

echo "Project files created ✅"

# ── DONE ──────────────────────────────────────────────
echo ""
echo "================================================"
echo " Bootstrap Complete! ✅"
echo "================================================"
echo ""
echo " User             : mlops"
echo " Project location : $MLOPS_DIR"
echo " Virtual env      : $VENV_DIR"
echo " JupyterLab config: $MLOPS_DIR/jupyter_lab_config.py"
echo ""
echo " Next steps:"
echo " 1. Open port 8888 in AWS Security Group"
echo " 2. Run the following to start JupyterLab:"
echo "    source $VENV_DIR/bin/activate"
echo "    jupyter lab --config=$MLOPS_DIR/jupyter_lab_config.py --no-browser &"
echo ""
echo " 3. Access JupyterLab at:"
echo "    http://<your-ec2-public-ip>:8888"
echo "================================================"

