#!/bin/sh

if [ "$1" == "" ]; then
	echo "Syntax: "$0" <DIRECTORY_OR_FILENAME>"
	exit 1
else
	if [ -d "$1" ]; then

		echo "\nLooking for lines ending with integers..."

		find $1 -type f -name '*.rle' -exec awk --posix '{if ($0~/^.*[0-9]$/ && $0!~/^(#)/ && $0!~/^.*(=).*$/) print "WARN: "FILENAME"@line "NR" ends with INTEGER!!!"}' \{\} \;

		echo "...done!"

		echo "\nIf you can't see any WARNs above, then chill out."

	else
                echo "No files found @ given location."
                exit 1;
        fi

fi
