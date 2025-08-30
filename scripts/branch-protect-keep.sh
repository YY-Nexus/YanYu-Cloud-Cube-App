#!/usr/bin/env bash
while read repo; do
  gh api -X PUT repos/YY-Nexus/$repo/branches/main/protection \
    -f required_status_checks='["ci"]' \
    -f enforce_admins=true \
    -f required_pull_request_reviews.dismiss_stale_reviews=true
done < keep.txt