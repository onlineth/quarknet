#!/bin/sh

SOURCE=$1
TAG=$2

usage() {
	echo "Usage: tag.sh <source> <tag>"
	echo "Example: tag.sh branches/1.0 tags/1.0.2"
}

error() {
	echo "Error: $1"
	usage
	exit 1
}

if [ "$SOURCE" == "" ]; then
	error "Missing source"
fi

if [ "$TAG" == "" ]; then
	error "Missing tag"
fi

echo "svn copy -m "Tagging $SOURCE as $TAG" https://svn.ci.uchicago.edu/svn/i2u2/$SOURCE https://svn.ci.uchicago.edu/svn/i2u2/$TAG"
sleep 10
svn copy -m "Tagging $SOURCE as $TAG" https://svn.ci.uchicago.edu/svn/i2u2/$SOURCE https://svn.ci.uchicago.edu/svn/i2u2/$TAG
