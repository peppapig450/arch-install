#!/bin/bash
attempt1() {
	var=$(uname -r | awk -F- '{print $2}')
	if [[ "$var" == 'arch1' ]]; then
		header=""
	elif [[ "$var" =~ [0-9] ]]; then
		header=$(uname -r | awk -F- '{print $3}')
		if [[ "$header" =~ [0-9] ]]; then
			header=$(uname -r | awk -F- '{print $4}')
		fi
	fi
	if [[ -z "$header" ]]; then 
		headers="linux-headers"
	else
		headers="linux-${header}-headers"
	fi
	printf '%s\n' "$(uname -r)"
	printf '%s\n' "$header"
	printf '%s\n' "$headers"
}

attempt2() {
	for header in $(find /boot -maxdepth 1 -type f); do
		printf '%s' "$header" | awk -F- '/vmlinuz/ {print $3}'
	done
}
attempt1
