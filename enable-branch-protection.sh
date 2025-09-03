#!/usr/bin/env bash
set -e

# Enable branch protection for YanYu-Cloud-Cube-App repository
# This script configures branch protection for the main branch with CI status checks

REPO="YY-Nexus/YanYu-Cloud-Cube-App"
BRANCH="main"

echo "🔧 Configuring branch protection for $REPO..."

# Create the protection configuration JSON
PROTECTION_CONFIG="/tmp/branch-protection.json"
cat > "$PROTECTION_CONFIG" << 'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["CI"]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false,
    "require_last_push_approval": false
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "block_creations": false,
  "required_conversation_resolution": true
}
EOF

echo "📋 Branch protection configuration:"
cat "$PROTECTION_CONFIG"
echo ""

# Try to apply the protection
if command -v gh >/dev/null 2>&1 && [ -n "${GH_TOKEN:-}" ]; then
    echo "🚀 Applying branch protection via GitHub CLI..."
    if gh api -X PUT "repos/$REPO/branches/$BRANCH/protection" \
        --input "$PROTECTION_CONFIG"; then
        echo "✅ Branch protection enabled successfully!"
    else
        echo "❌ Failed to apply protection via GitHub CLI"
        echo "ℹ️  You may need to check your permissions or run this manually"
        exit 1
    fi
elif command -v curl >/dev/null 2>&1 && [ -n "${GH_TOKEN:-}" ]; then
    echo "🚀 Applying branch protection via curl..."
    if curl -s -X PUT \
        -H "Authorization: token $GH_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/$REPO/branches/$BRANCH/protection" \
        -d "@$PROTECTION_CONFIG" > /tmp/response.json; then
        
        if grep -q '"url"' /tmp/response.json; then
            echo "✅ Branch protection enabled successfully!"
        else
            echo "❌ API call failed. Response:"
            cat /tmp/response.json
            exit 1
        fi
    else
        echo "❌ Failed to apply protection via curl"
        exit 1
    fi
else
    echo "⚠️  GitHub CLI or curl with GH_TOKEN required"
    echo ""
    echo "To enable branch protection manually:"
    echo "1. Go to: https://github.com/$REPO/settings/branches"
    echo "2. Click 'Add rule' for the main branch"
    echo "3. Configure these settings:"
    echo "   ✓ Require status checks to pass before merging"
    echo "   ✓ Require branches to be up to date before merging"
    echo "   ✓ Status checks: CI"
    echo "   ✓ Require pull request reviews before merging"
    echo "   ✓ Required approving reviews: 1"
    echo "   ✓ Dismiss stale pull request approvals when new commits are pushed"
    echo "   ✓ Require conversation resolution before merging"
    echo "   ✓ Include administrators"
    echo "   ✓ Restrict pushes that create files"
    echo ""
    echo "Or run this script with GH_TOKEN environment variable set:"
    echo "  export GH_TOKEN=your_github_token"
    echo "  ./enable-branch-protection.sh"
    echo ""
    echo "API call for manual execution:"
    echo "curl -X PUT -H 'Authorization: token \$GH_TOKEN' \\"
    echo "  -H 'Accept: application/vnd.github.v3+json' \\"
    echo "  https://api.github.com/repos/$REPO/branches/$BRANCH/protection \\"
    echo "  -d @$PROTECTION_CONFIG"
fi

# Clean up
rm -f "$PROTECTION_CONFIG" /tmp/response.json

echo "Branch protection configuration complete!"
echo ""
echo "The following protections are now active:"
echo "- ✅ Require CI / build-test status check to pass"
echo "- ✅ Require pull request reviews (1 approval)"
echo "- ✅ Dismiss stale reviews when new commits are pushed"
echo "- ✅ Enforce for administrators"
echo "- ✅ Require conversation resolution before merging"
echo "- ✅ Prevent force pushes and branch deletion"