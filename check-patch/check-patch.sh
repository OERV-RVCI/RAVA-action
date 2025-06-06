#!/bin/bash
set -e
set -x


# sudo dnf install -y git clang-tools-extra
# sudo pip install ply GitPython

git log --oneline "${SRC_REF}".."${FETCH_REF}"

patch_dir=patch-$(date +%Y%m%d%H%M%S)
rm -rf "$patch_dir" || true
mkdir -p "$patch_dir"
git format-patch "${SRC_REF}".."${FETCH_REF}" -o "$patch_dir"

echo "begin to check patches..."
set +e
./scripts/checkpatch.pl "$patch_dir"/*.patch --show-types \
    --ignore CONFIG_DESCRIPTION,FILE_PATH_CHANGES,GERRIT_CHANGE_ID,GIT_COMMIT_ID,UNKNOWN_COMMIT_ID,FROM_SIGN_OFF_MISMATCH,REPEATED_WORD,COMMIT_COMMENT_SYMBOL,BLOCK_COMMENT_STYLE,AVOID_EXTERNS,AVOID_BUG > "$patch_dir/checkpatch.log"
total_error=$(grep -cE "ERROR" "$patch_dir/checkpatch.log")
total_warn=$(grep -cE "WARNING" "$patch_dir/checkpatch.log")
set -e

echo "check patches result: $total_error errors, $total_warn warnings." > check-patch-result