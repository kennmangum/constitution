# Ollama Setup Troubleshooting

If `setup.sh` fails or Ollama won't install, try these steps:

---

## What is Ollama?

**Ollama** is a free, open-source tool that lets you run AI models (like ChatGPT, but smaller and local) on your own computer. No cloud. Your data stays private.

**Think of it like**: Installing a calculator app that runs offline, instead of using a web-based calculator that sends your numbers to someone else's server.

---

## Installation Steps (Manual)

### **Mac**

```bash
# Download and install Ollama
curl https://ollama.ai/install.sh | sh

# Or download from website
open https://ollama.ai/download

# Verify it works
ollama --version
```

### **Linux (Ubuntu/Debian)**

```bash
# Install Ollama
curl https://ollama.ai/install.sh | sh

# Start Ollama service
ollama serve &

# Verify it works
ollama --version
```

### **Windows (WSL)**

1. Install WSL2 first: https://learn.microsoft.com/en-us/windows/wsl/install
2. Open WSL terminal
3. Run Linux installation steps above

---

## Common Issues

### **"Command not found: ollama"**

**Problem**: Ollama isn't installed or isn't in your PATH.

**Fix**:
```bash
# Check if Ollama binary exists
which ollama

# If not found, reinstall
curl https://ollama.ai/install.sh | sh

# Restart your terminal
```

### **"Connection refused" or "Server not running"**

**Problem**: Ollama service isn't running.

**Fix**:
```bash
# Start Ollama server in background
ollama serve &

# Wait 5 seconds, then try again
sleep 5
ollama list
```

### **"Failed to pull model"**

**Problem**: Network issue or insufficient disk space.

**Fix**:
```bash
# Check disk space (need ~10GB free)
df -h

# Retry model download
ollama pull mistral:7b

# If still fails, try smaller model first
ollama pull mistral:latest
```

### **"Permission denied"**

**Problem**: Script doesn't have execute permissions.

**Fix**:
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Try again
./scripts/setup.sh
```

---

## Verify Everything Works

After installation, test Ollama:

```bash
# 1. Check version
ollama --version

# 2. List installed models
ollama list

# 3. Test a simple prompt
ollama run mistral:7b "Say hello"
```

**Expected output**: Mistral should respond with "Hello!" or similar.

---

## Still Having Issues?

1. **Check Ollama docs**: https://github.com/jmorganca/ollama#readme
2. **Ask Kenneth**: Reply to the quest invitation email
3. **Open an issue**: Post in the repo's Issues tab with error output

---

**System Requirements Reminder**:
- 8GB RAM minimum (16GB recommended)
- ~10GB free disk space
- macOS, Linux, or Windows WSL2
