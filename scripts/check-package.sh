#!/usr/bin/env bash
# check-package.sh — the `hex-package` gate: build the Hex tarball and prove it carries the files `mix.exs` declares.
#
# A consumer of ex-bdd needs the built tarball to hold the library, its metadata, and its guides, and each of those
# is easy to lose without noticing: a `files:` entry renamed without updating `mix.exs`, or a guide moved without
# updating the extras, ships a package that installs but does not document.
#
# Usage: bash scripts/check-package.sh      (from any directory; it checks the repository this script lives in)
# Exit:  0 when the tarball names the app and lists the declared files; non-zero otherwise, naming what is wrong.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# The tarball is built into a throwaway directory, removed on every exit path, so the check leaves no artifact behind.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

(cd "$root" && mix hex.build --output "$tmp/package.tar" >/dev/null)

tars=("$tmp"/*.tar)
if [ "${#tars[@]}" -ne 1 ] || [ ! -f "${tars[0]}" ]; then
	echo "check-package: expected exactly one tarball in the build output, found ${#tars[@]}" >&2
	exit 1
fi
tarball="${tars[0]}"

# A Hex tarball wraps `contents.tar.gz`, which holds the files, beside its metadata. Each listing is captured before
# it is searched. A `grep -q` that stops at its first match would otherwise close the pipe under `tar`, whose SIGPIPE
# status `pipefail` turns into a false answer, a false pass for a later check.
outer="$(tar -tf "$tarball")"
for member in metadata.config contents.tar.gz; do
	if ! grep -Eq "(^|/)${member//\./\\.}$" <<<"$outer"; then
		echo "check-package: ${tarball##*/} is not a Hex package tarball (missing $member)" >&2
		exit 1
	fi
done
tar -xf "$tarball" -C "$tmp" contents.tar.gz
listing="$(tar -tzf "$tmp/contents.tar.gz")"
for member in mix.exs README.md LICENSE CHANGELOG.md .formatter.exs lib/ex_bdd.ex docs/getting-started.md; do
	if ! grep -Eq "(^|/)${member//\./\\.}$" <<<"$listing"; then
		echo "check-package: ${tarball##*/} does not list $member" >&2
		exit 1
	fi
done

echo "check-package: ${tarball##*/} lists the declared files"
