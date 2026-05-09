#!/bin/bash
# Install git hooks for secret detection
# Run this after cloning the repo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="$SCRIPT_DIR/.git/hooks"

if [ ! -d "$HOOKS_DIR" ]; then
    echo "❌ Error: .git/hooks directory not found. Are you in a git repository?"
    exit 1
fi

echo "Installing git hooks..."

# Pre-commit hook
cat > "$HOOKS_DIR/pre-commit" << 'HOOKEOF'
#!/bin/bash
set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔒 Running secret detection pre-commit hook..."

if ! command -v gitleaks &> /dev/null; then
    echo -e "${YELLOW}⚠️  gitleaks not found. Install with: brew install gitleaks${NC}"
else
    echo "🔍 Running gitleaks..."
    if gitleaks protect --staged --verbose; then
        echo -e "${GREEN}✅ gitleaks: no secrets detected${NC}"
    else
        echo -e "${RED}❌ gitleaks: POTENTIAL SECRETS DETECTED!${NC}"
        echo -e "${RED}   Commit blocked. Use --no-verify to bypass (not recommended).${NC}"
        exit 1
    fi
fi

echo ""

if ! command -v semgrep &> /dev/null; then
    echo -e "${YELLOW}⚠️  semgrep not found. Install with: brew install semgrep${NC}"
else
    echo "🔍 Running semgrep..."
    STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | tr '\n' ' ')
    if [ -z "$STAGED_FILES" ]; then
        echo -e "${GREEN}✅ semgrep: no staged files to scan${NC}"
    else
        if semgrep scan --config=p/secrets --config=p/default --error --quiet $STAGED_FILES; then
            echo -e "${GREEN}✅ semgrep: no security issues detected${NC}"
        else
            echo -e "${RED}❌ semgrep: SECURITY ISSUES DETECTED!${NC}"
            echo -e "${RED}   Commit blocked. Use --no-verify to bypass (not recommended).${NC}"
            exit 1
        fi
    fi
fi

echo ""
echo -e "${GREEN}🚀 All checks passed. Proceeding with commit.${NC}"
HOOKEOF

chmod +x "$HOOKS_DIR/pre-commit"
echo "✅ pre-commit hook installed"

# Pre-push hook
cat > "$HOOKS_DIR/pre-push" << 'HOOKEOF'
#!/bin/bash
set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔒 Running secret detection pre-push hook..."

if ! command -v gitleaks &> /dev/null; then
    echo -e "${YELLOW}⚠️  gitleaks not found. Install with: brew install gitleaks${NC}"
else
    echo "🔍 Running gitleaks on repository..."
    if gitleaks detect --source . --verbose; then
        echo -e "${GREEN}✅ gitleaks: no secrets detected in repository${NC}"
    else
        echo -e "${RED}❌ gitleaks: POTENTIAL SECRETS DETECTED in history!${NC}"
        echo -e "${RED}   Push blocked. Use --no-verify to bypass (not recommended).${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}🚀 All checks passed. Proceeding with push.${NC}"
HOOKEOF

chmod +x "$HOOKS_DIR/pre-push"
echo "✅ pre-push hook installed"

echo ""
echo "🎉 Git hooks installed successfully!"
echo "   - pre-commit: scans staged files with gitleaks + semgrep"
echo "   - pre-push: scans full repo history with gitleaks"
echo ""
echo "To bypass hooks in emergencies: git commit --no-verify  or  git push --no-verify"
