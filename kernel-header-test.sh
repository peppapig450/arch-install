#!/bin/bash
attempt1() {
	set -x
	set -v
	var=$(uname -r | awk -F- '{print $2}')
	if [[ "$var" =~ [0-9] ]]; then
		header=$(uname -r | awk -F- '{print $3}')
		if [[ "$header" =~ [0-9] ]]; then
			header=$(uname -r | awk -F- '{print $4}')
		fi
	fi
	printf '%s\n' "$(uname -r)"
	printf '%s\n' "$header"
}

attempt2() {
	for header in $(find /boot -maxdepth 1 -type f); do
		printf '%s' "$header" | awk -F- '/vmlinuz/ {print $3}'
	done
}
attempt2
