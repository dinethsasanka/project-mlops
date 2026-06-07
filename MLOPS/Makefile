.PHONY: setup data train test clean jupyter lint format format-check all

# ── Setup ────────────────────────────────────────────
setup:
	python3 -m venv ml-env
	ml-env/bin/pip install --upgrade pip
	ml-env/bin/pip install -r requirements.txt
	@echo "✅ Environment setup complete"

# ── Data Processing ──────────────────────────────────
data:
	ml-env/bin/python src/data/process_data.py
	@echo "✅ Data processing complete"

# ── Model Training ───────────────────────────────────
train:
	ml-env/bin/python src/models/train.py
	@echo "✅ Model training complete"

# ── Tests ────────────────────────────────────────────
test:
	ml-env/bin/pytest tests/ -v
	@echo "✅ Tests complete"

# ── JupyterLab ───────────────────────────────────────
jupyter:
	ml-env/bin/jupyter lab \
		--config=jupyter_lab_config.py \
		--no-browser &
	@echo "✅ JupyterLab started at port 8888"

# ── Clean ────────────────────────────────────────────
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	rm -rf .pytest_cache
	rm -rf models/*
	@echo "✅ Cleanup complete"

# ── Code Quality ─────────────────────────────────────
lint:
	ml-env/bin/ruff check src/
	@echo "✅ Ruff check passed"

format:
	ml-env/bin/black src/
	@echo "✅ Black formatting applied"

fromat-check:
	ml-env/bin/black --check src/
	@echo "✅ Black check passed"

# ── All ──────────────────────────────────────────────
all: setup data train test
	@echo ""
	@echo "================================================"
	@echo " All tasks completed successfully! ✅"
	@echo "================================================"
