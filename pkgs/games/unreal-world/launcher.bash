#!/usr/bin/env bash
#
# Description:
# This file is part of UnReal World RPG version 3.50beta
# It launches UrW and set up configs
#
# License only for this 'urw'-file not for whole UnReal World RPG codebase
# or attached files:
#
# Copyright (c) 2017 Tuukka Pasanen <tuukka.pasanen@ilmi.fi>>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#


IFS=$'\n'
URW_OS=$(uname)
URW_BIN="urw3-bin"
URW_VERSION="@version@"

if [ "${URW_OS}" == "Linux" ]; then
   echo " > Running under: Linux"
   URW_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/UnRealWorld"
   URW_DATA="@out@/share/unreal-world"
   URW_BIN_DIR="@out@/share/unreal-world"
fi

URW_HOME_GFX="${URW_HOME}/truegfx"
URW_HOME_TILE="${URW_HOME}/truetile"
URW_HOME_AUDIO="${URW_HOME}/audio"
URW_HOME_DEFAULTS="${URW_HOME}/defaults"
URW_HOME_MESSAGES="${URW_HOME}/messages"
URW_HOME_GAMEINFO="${URW_HOME}/gameinfo"

#
# Files that are absolutly needed
#
URW_FILES="${URW_DATA}/truegfx/*.jpg\n\
${URW_DATA}/truegfx/*.png\n\
${URW_DATA}/truetile/*.png\n\
${URW_DATA}/truetile/*.txt\n\
${URW_DATA}/audio/*.wav\n\
${URW_DATA}/audio/*.ogg\n\
${URW_DATA}/gameinfo/*.txt\n\
${URW_DATA}/defaults/urw_ini.def\n\
${URW_DATA}/messages/*.txt\n\
${URW_DATA}/*.RIT\n\
${URW_DATA}/*.arr\n\
${URW_DATA}/*.txt\n\
${URW_DATA}/*.TXT\n\
${URW_DATA}/*.FNT\n\
${URW_DATA}/*.NFO\n\
${URW_DATA}/*.STD\n\
${URW_DATA}/RNDCAMP.*\n\
${URW_DATA}/*.dat\n\
${URW_DATA}/*.nfo"

#
# Files that needs to be copied to user dir
#
URW_FILE_AUDIO=(${URW_HOME_AUDIO}/throw.wav ${URW_HOME_AUDIO}/hitplr.wav \
${URW_HOME_AUDIO}/smear.wav ${URW_HOME_AUDIO}/bird_peippo.wav ${URW_HOME_DEFAULTS}/urw_ini.def)

for dir in "${URW_HOME}" "${URW_HOME_GFX}" "${URW_HOME_TILE}" \
"${URW_HOME_AUDIO}" "${URW_HOME_DEFAULTS}" "${URW_HOME_MESSAGES}" "${URW_HOME_GAMEINFO}"
do
    if [ ! -d "${dir}" ]
    then
      mkdir -p "${dir}"
    fi
done

# Then go to home dir
if [ ! -d "${URW_HOME}" ]
then
    if [ -e "${URW_HOME}" ]
    then
        echo " ! Creating data directory at: '${URW_HOME}'"
        mkdir -p "${URW_HOME}"
    else
        echo " ! '${URW_HOME}' exists but is not a directory, exiting!"
        exit 1
    fi
fi
cd "${URW_HOME}"

#
# We have to sanitize old links so that
# URW doesn't crash on start
#
for FILE in $(find -L "${URW_HOME}" -type l)
do
  echo " ! Removing dangling symbolic link: '${FILE}'"
  rm -f "${FILE}"
done

for file in $(echo -e "${URW_FILES}")
do
  URW_LINK_FILE=$(echo "${file}" | sed -e "s#${URW_DATA}#${URW_HOME}#")

  # File doesn't exists link/copy it
  if [ ! -e  "${URW_LINK_FILE}" ]
  then
     #
     # Some files we have to copy
     # Some files we have to link
     # Don't ask why but that's the way it's going to be
     #
     if [[ ${URW_FILE_AUDIO[*]} =~ "${URW_LINK_FILE}" ]]
     then
        cp "${file}" "${URW_LINK_FILE}"
     else
        ln -sf "${file}" "${URW_LINK_FILE}"
     fi
   else
     #
     # Be sure that files that neededs to be copied are copied
     #
     if [[ ${URW_FILE_AUDIO[*]} =~ "${URW_LINK_FILE}" ]]
     then
        if [ -L  "${URW_LINK_FILE}" ]
        then
           rm -f "${URW_LINK_FILE}"
           cp "${file}" "${URW_LINK_FILE}"
        fi
     fi
    fi
done

if [ -x "${URW_BIN_DIR}"/"${URW_BIN}" ]
then
    # Launch urw!
    echo " > Entering The UnReal World RPG Version ${URW_VERSION}"
    echo " > App data dir is: '${URW_DATA}'"
    echo " > App home dir is: '${URW_HOME}'"
    "${URW_BIN_DIR}"/"${URW_BIN}"
else
    echo "Can't find binary '${URW_BIN_DIR}/${URW_BIN}' exiting!"
    exit 1
fi
