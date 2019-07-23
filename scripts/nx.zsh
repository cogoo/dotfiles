#!/bin/sh

if [ "$1" != "" ]; then
	echo "📦  Creating workspace $1"
	npm init nx-workspace $1

	cd "$1"

	ng add @nrwl/angular # Adds Angular capabilities
	ng add @nrwl/nest # Adds Nest capabilities

else 
	echo "A project name is required"
fi


