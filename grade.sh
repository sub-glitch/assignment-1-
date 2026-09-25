#!/usr/bin/env bash

set -u

PASS=0
FAIL=0

pass() {
    echo "PASS: $1"
    PASS=$((PASS+1))
}

fail() {
    echo "FAIL: $1"
    FAIL=$((FAIL+1))
}

echo "======================================"
echo "Assignment 1 - Local Grader"
echo "Linux/Bash/Networking/Git"
echo "======================================"
echo

# Required files
for f in README.md system-info.sh disk-check.sh network-check.sh; do
    if [[ -f "$f" ]]; then
        pass "Required file exists: $f"
    else
        fail "Missing required file: $f"
    fi
done

mkdir -p logs

# Syntax
for f in system-info.sh disk-check.sh network-check.sh; do
    if [[ -f "$f" ]]; then
        if bash -n "$f" >/dev/null 2>&1; then
            pass "Bash syntax: $f"
        else
            fail "Bash syntax error: $f"
        fi
    fi
done

# Executable check
for f in system-info.sh disk-check.sh network-check.sh; do
    if [[ -f "$f" && -x "$f" ]]; then
        pass "Executable: $f"
    else
        fail "Not executable: $f"
    fi
done

# system-info.sh
if [[ -x ./system-info.sh ]]; then
    output=$(./system-info.sh 2>&1)
    rc=$?

    if [[ $rc -eq 0 ]]; then
        pass "system-info.sh exits successfully"
    else
        fail "system-info.sh exit code is $rc"
    fi

    for term in "hostname" "user" "kernel" "uptime"; do
        if echo "$output" | grep -qi "$term"; then
            pass "system-info.sh contains '$term' information"
        else
            fail "system-info.sh does not appear to contain '$term' information"
        fi
    done
fi

# disk-check.sh argument validation
if [[ -x ./disk-check.sh ]]; then

    ./disk-check.sh 0 >/dev/null 2>&1
    if [[ $? -eq 2 ]]; then
        pass "disk-check rejects threshold 0 with exit code 2"
    else
        fail "disk-check should reject threshold 0 with exit code 2"
    fi

    ./disk-check.sh 101 >/dev/null 2>&1
    if [[ $? -eq 2 ]]; then
        pass "disk-check rejects threshold 101 with exit code 2"
    else
        fail "disk-check should reject threshold 101 with exit code 2"
    fi

    ./disk-check.sh abc >/dev/null 2>&1
    if [[ $? -eq 2 ]]; then
        pass "disk-check rejects non-numeric threshold"
    else
        fail "disk-check should reject non-numeric threshold"
    fi

    ./disk-check.sh 100 / >/dev/null 2>&1
    rc=$?

    if [[ $rc -eq 0 || $rc -eq 1 ]]; then
        pass "disk-check accepts valid threshold/path"
    else
        fail "disk-check failed valid input"
    fi
fi

# network-check.sh validation
if [[ -x ./network-check.sh ]]; then

    ./network-check.sh >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        pass "network-check rejects missing host"
    else
        fail "network-check should reject missing host"
    fi

    ./network-check.sh localhost >/dev/null 2>&1
    rc=$?

    if [[ $rc -eq 0 || $rc -eq 1 ]]; then
        pass "network-check accepts localhost"
    else
        fail "network-check failed localhost test unexpectedly"
    fi

    ./network-check.sh localhost 0 >/dev/null 2>&1
    if [[ $? -eq 2 ]]; then
        pass "network-check rejects port 0"
    else
        fail "network-check should reject port 0 with exit code 2"
    fi

    ./network-check.sh localhost 65536 >/dev/null 2>&1
    if [[ $? -eq 2 ]]; then
        pass "network-check rejects port 65536"
    else
        fail "network-check should reject port 65536 with exit code 2"
    fi

    ./network-check.sh localhost abc >/dev/null 2>&1
    if [[ $? -eq 2 ]]; then
        pass "network-check rejects non-numeric port"
    else
        fail "network-check should reject non-numeric port"
    fi
fi

# Logging
if find logs -type f -not -name '.gitkeep' -print -quit 2>/dev/null | grep -q .; then
    pass "Log file was created"
else
    fail "No log file found under logs/"
fi

# Git checks
if command -v git >/dev/null 2>&1 &&
   git rev-parse --is-inside-work-tree >/dev/null 2>&1; then

    commits=$(git rev-list --count HEAD 2>/dev/null || echo 0)

    if [[ "$commits" -ge 5 ]]; then
        pass "Git has at least 5 commits"
    else
        fail "Git has fewer than 5 commits"
    fi

    branches=$(git for-each-ref \
        --format='%(refname:short)' \
        refs/heads 2>/dev/null |
        grep -vE '^(main|master)$' |
        wc -l |
        tr -d ' ')

    if [[ "$branches" -ge 1 ]]; then
        pass "At least one non-main local branch exists"
    else
        echo "WARN: no local feature branch found; inspect Git history manually"
    fi

else
    echo "WARN: Git repository checks skipped"
fi

echo
echo "======================================"
echo "Passed: $PASS"
echo "Failed: $FAIL"
echo "======================================"

if [[ $FAIL -eq 0 ]]; then
    exit 0
else
    exit 1
fi