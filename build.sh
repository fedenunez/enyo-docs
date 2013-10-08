#!/bin/bash

# build.sh
#
# A bash shell script that reads in a list of markdown (.md) files
# from a manifest (outline.txt) and uses Pandoc to convert them to HTML;
# the resulting files are written to an output directory (./output). If
# the 'assets' subdirectory exists, its contents are copied to the
# output directory.

docSourceRoot=( $(pwd) )

outputDir=${docSourceRoot}/output
outlineFile=${docSourceRoot}/outline.txt

while test $# -gt 0; do
	case "$1" in
		--head)
			shift
			headFilePath=${docSourceRoot}/$1
			shift
			;;
		--header)
			shift
			headerFilePath=${docSourceRoot}/$1
			shift
			;;
		--footer)
			shift
			footerFilePath=${docSourceRoot}/$1
			shift
			;;
		*)
			break
			;;
	esac
done

pandocOptions=""
if  ! [ -z "$headFilePath" ] && [ -f $headFilePath ]; then
	pandocOptions="${pandocOptions} -H ${headFilePath}"
fi

if ! [ -z "$headerFilePath" ] && [ -f $headerFilePath ]; then
	pandocOptions="${pandocOptions} -B ${headerFilePath}"
fi

if ! [ -z "$footerFilePath" ] && [ -f $footerFilePath ]; then
	pandocOptions="${pandocOptions} -A ${footerFilePath}"
fi

declare -a outlineArray
index=0
foundEmptyLine=0

# read in all lines from outline file, until we reach the end or an empty line
while read line; do
	if [ $((foundEmptyLine)) -eq 0 ]; then
		myLine=$(echo $line)
#		echo "myLine: $myLine"
		strlen=$(echo ${#myLine})
#		echo "strlen: $strlen"
		if [ $strlen -gt "0" ]; then
#			echo "index: $index"
			outlineArray[$index]=$myLine
			let index++
		else
#			echo "found empty line"
			foundEmptyLine=1
			break
		fi
	fi
done <$outlineFile
len=${#outlineArray[*]}

# remove, then recreate output directory
rm -rf ${outputDir}
mkdir -p ${outputDir}

# create output subdirectories
x=0
previousNameToTest=
while [ $x -lt $len ]; do
	nameToTest=${outlineArray[$x]%/*.md}
	if [[ $nameToTest != $previousNameToTest ]]; then
		potentialDirName=$docSourceRoot/$nameToTest
		if [ -d $potentialDirName ]; then
			mkdir -p $outputDir/$nameToTest
#			echo "creating directory ${outputDir}/${nameToTest}"
		fi
	fi
	let x++
	previousNameToTest=$nameToTest
done

# calculate output file paths and generate HTML files
y=0
while [ $y -lt $len ]; do
	sourceFilePath=${docSourceRoot}/${outlineArray[$y]}
	if [ -f ${sourceFilePath} ]; then
		lenSourceFilePath=${#sourceFilePath}
		pathExt=${sourceFilePath:lenSourceFilePath-3:3}
		if [ ${pathExt} == ".md" ]; then
			targetFilePath=$outputDir/${outlineArray[$y]%.md}.html
#			echo "targetFilePath: ${targetFilePath}"
			# Create HTML file
			pandoc -s $pandocOptions -f markdown -t html -o $targetFilePath $sourceFilePath
		fi
	fi
	let y++
done

# Copy over the assets directory, if it exists

assetsSourceDir=${docSourceRoot}/assets

if [ -d $assetsSourceDir ]; then
	assetsTargetDir=$outputDir/assets
	mkdir -p $assetsTargetDir
	cp $assetsSourceDir/* $assetsTargetDir/
fi
exit