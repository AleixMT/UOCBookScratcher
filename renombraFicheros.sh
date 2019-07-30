#!/usr/bin/env bash
for filename in $(ls); do newname=$(echo $filename | tr -d ',' ); mv $filename $newname; done