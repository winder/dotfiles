#!/bin/bash

# Copyright 2020 Patrick Nagel and contributors
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

echo "== Merge GoPro MP4s =="
echo

if [[ "${1}" == "" ]] || [[ "${1}" == "-h" ]] || [[ "${1}" == "--help" ]]; then
  echo "Syntax: $0 <output directory> [<start date/time>]
  
This script looks for GoPro .MP4 files in the current directory
and seamlessly concatenates them using ffmpeg into one file per recorded
video. The resulting single GoPro<number>.mp4 file is written to the
output directory specified as first argument.

As an optional second parameter, a date/time can be provided. The script
will then only process videos that have been recorded on/after that
date/time. This is useful when you want to skip some older videos that
you have not yet deleted from the SD card. On Mac OS X the date must be
formatted like this: yyyy-mm-ddThh:mm:ss  -- e.g. 2020-10-03T10:20:00
On Linux, there is some more flexibility (anything that GNU date can
interpret, e.g. \"yesterday\".

Note: Time loop videos are ignored.

Typical workflow:
- Take MicroSD card out of the GoPro and put it into the SD card adapter
- Insert SD card into computer
- Open terminal and change directory to SD card mount point
- Run this script and provide a directory on the computer's hard
  drive as parameter
- Use any video processing application to work on the merged file(s)"
  exit 0
fi

if [ ! -d "${1}" ]; then
  echo "${1} is not an existing directory."
  exit 1
else
  targetdir="${1}"
  echo "Target directory: ${1}"
fi

if ! ffmpeg -version >/dev/null; then
  echo "ffmpeg not found, make sure that it is installed."
  exit 1
fi

# Validate given date
if [[ "${2}" == "" ]]; then
  startdate="1980-01-01T00:00:00"
else
  startdate="${2}"
  if [[ "$OSTYPE" =~ "darwin" ]]; then
    # Even though 'find' on OS X seems to be more flexible than 'date', we need to check that
    # it's a valid date somehow. Currently I see no other way than forcing a specific format
    # onto the user... Would be really nice if GNU date was available on OS X :)
    if ! date -jf %Y-%m-%dT%H:%M:%S "${startdate}" >/dev/null; then
        echo "${startdate} is not a valid date. Please use format \"yyyy-mm-ddThh:mm:ss\"."
        exit 1
    fi
    LC_TIME="en_US.UTF-8"
    echo "Considering only files from $(date -jf %Y-%m-%dT%H:%M:%S "${startdate}") onwards..."
    # Append timezone, or else 'find' will default to UTC.
    startdate="$startdate$(date +%z)"
    echo  
  else
    if ! date -d "${startdate}" >/dev/null; then
        echo "${startdate} is not a valid date."
        exit 1
    fi
    LC_TIME="en_US.UTF-8"
    echo "Considering only files from $(date -d "${startdate}") onwards..."
    echo
  fi
fi

IFS='
'
findpattern='\./G[HXPO][0-9P][0-9R].*\.MP4'
declare -a filelist videonumbers

echo "File list:"
filelist=( $(find . -maxdepth 1 -newermt "${startdate}" -regex "${findpattern}" | sort) )
printf '%s\n' "${filelist[@]}"

echo

echo "Video numbers:"
videonumbers=( $(find . -maxdepth 1 -newermt "${startdate}" -regex "${findpattern}" | sed -e 's|\./G[XHPO][0-9P][0-9R]\(....\)\.MP4$|\1|' | sort -u) )
printf '%s\n' "${videonumbers[@]}"

echo
echo "Press Enter to proceed, Ctrl-C to cancel."
read

echo "Processing videos..."
for videonumber in ${videonumbers[@]}; do
  filelistname="./filelist.tmp"
  echo "WRITE TEST" >"${filelistname}"
  if [ $? != 0 ]; then
    echo "Creating temporary file failed."
    exit 1
  fi
  echo "- Creating temporary ffmpeg file list for video ${videonumber}..."
  find . -maxdepth 1 -newermt "${startdate}" -regex "\./G[HXPO][0-9P][0-9R]${videonumber}\.MP4" | sort | sed -e's|^./|file |' >${filelistname}
  cat $filelistname
  echo "- Running ffmpeg..."
  ffmpeg -n -f concat -i ${filelistname} -c copy "${targetdir}/GoPro${videonumber}.mp4" || {
    echo "ffmpeg failed (see above)."
    rm -f ${filelistname}
    exit 1;
  }
  echo "- Taking over timestamp..."
  touch -r "$(head -n 1 ${filelistname} | cut -d' ' -f 2)" "${targetdir}/GoPro${videonumber}.mp4"
  rm -f ${filelistname}
done

echo
echo "Resulting (merged) file(s):"
for videonumber in ${videonumbers[@]}; do
  ls -lh "${targetdir}/GoPro${videonumber}.mp4"
done
