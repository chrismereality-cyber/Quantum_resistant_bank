#!/bin/bash
# ==========================================
# Git Auto-Sync for Quantum Resistant Bank
# ==========================================

cd ~/quantum_resistant_bank || exit

echo "🔄 Pulling latest changes..."
git pull --rebase origin main

echo "💾 Adding local changes..."
git add -A

# Commit message with date/time
COMMIT_MSG="Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MSG" 2>/dev/null || echo "No new changes to commit."

echo "🚀 Pushing to GitHub..."
git push origin main

echo "✅ Sync complete!"
git config user.email "231793310+chrismereality-cyber@users.noreply.github.com"
