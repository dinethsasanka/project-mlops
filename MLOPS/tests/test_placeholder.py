# Customer Churn - Placeholder Tests
# Real tests will be added in later tasks

def test_project_structure():
    """Test that the project structure exists correctly."""
    import os

    required_dirs = [
        'data/raw',
        'data/processed',
        'models',
        'notebooks',
        'src/data',
        'src/features',
        'src/models',
        'src/utils',
        'tests',
        'configs'
    ]

    for directory in required_dirs:
        assert os.path.exists(directory), f"Missing directory: {directory}"
        print(f"✅ {directory} exists")

def test_init_files():
    """Test that __init__.py files exist in src/ subfolders."""
    import os

    required_inits = [
        'src/__init__.py',
        'src/data/__init__.py',
        'src/features/__init__.py',
        'src/models/__init__.py',
        'src/utils/__init__.py'
    ]

    for init_file in required_inits:
        assert os.path.exists(init_file), f"Missing: {init_file}"
        print(f"✅ {init_file} exists")
