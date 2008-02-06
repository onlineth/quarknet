#!/bin/sh

BRANCH=$1

usage() {
	echo "Usage: branch.sh <branch>"
	echo "Example: branch.sh branches/1.0"
}

error() {
	echo "Error: $1"
	usage
	exit 1
}

if [ "$BRANCH" == "" ]; then
	error "Missing branch"
fi

svn copy -m "Branching trunk to $BRANCH" https://svn.ci.uchicago.edu/svn/i2u2/trunk https://svn.ci.uchicago.edu/svn/i2u2/$BRANCH
