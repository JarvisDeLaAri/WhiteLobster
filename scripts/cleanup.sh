#!/bin/bash
# 🧹 White Lobster — Cleanup between model tests
# Run this after scoring a model to wipe everything it created

set -e

echo "🧹 Cleaning up..."

# Kill any running servers
pkill -f flask 2>/dev/null || true
pkill -f "python3 /workspace" 2>/dev/null || true

# Remove workspace files (keeps challenge-prompt.md)
find /workspace -type f ! -name 'challenge-prompt.md' ! -name 'TOOLS_GUIDE.md' -delete 2>/dev/null || true
find /workspace -type d -empty -delete 2>/dev/null || true

# Reset Apache to default
rm -rf /var/www/html/*
echo "<h1>Waiting for next model...</h1>" > /var/www/html/index.html
systemctl restart apache2 2>/dev/null || service apache2 restart 2>/dev/null || true

# Remove pip packages installed by the model
pip3 freeze 2>/dev/null | xargs pip3 uninstall -y 2>/dev/null || true

# Remove espeak-ng and any other apt packages the model installed
apt-get remove -y espeak-ng 2>/dev/null || true
apt-get autoremove -y 2>/dev/null || true

echo "🧹 Clean. Ready for next model."
