#!/bin/bash
#
#	Main script for generating project files on MacOS/Linux.
#
#	IMPORTANT! ------------------------------------------
#	* Do not change anything!
#	-----------------------------------------------------
#
#	Author: 	SWANN
#	Email:		sebastianswann@outlook.com
#
#	LICENSE ------------------------------------------
#
#	Copyright (c) 2016-2018 SWANN
#	All rights reserved.
#
#	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#	1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#	2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#	3. The names of the contributors may not be used to endorse or promote products derived from this software without specific prior written permission.
#
#	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# ------------------------------------------------------------------
# DEFAULTS                                                         |
# ------------------------------------------------------------------

# clear console
clear

# this script path
this=`dirname "$BASH_SOURCE"`

# color codes
DEFAULT='\033[0m'
YELLOW='\033[1;33m'
RED='\033[31m'

# ------------------------------------------------------------------
# HELPERS                                                          |
# ------------------------------------------------------------------

WriteErrorMessage () 
{
    printf "${RED}$1\n"
    printf "${DEFAULT}$2\n"
    read -n 1 -s -r -p "Press any key to continue..."
}

# ------------------------------------------------------------------
# MAIN                                                             |
# ------------------------------------------------------------------

# make sure we have GIT shell available
git --version > /dev/null 2>&1
if [ "$?" != "0" ]; then
    WriteErrorMessage "Git support seems to be unavailable." "Make sure that you have downloaded and installed:\n- Git Shell extension: https://git-scm.com/\n- Git LFS extension: https://git-lfs.github.com/"
    exit
fi

# make sure we have GIT LFS available
git lfs version > /dev/null 2>&1
if [ "$?" != "0" ]; then
    WriteErrorMessage "Git LFS support seems to be unavailable." "Make sure that you have downloaded and installed:\n- Git LFS extension: https://git-lfs.github.com/"
    exit
fi

# execute GIT commands
cd $this

printf "${YELLOW}Reseting main repo...\n${DEFAULT}"
git reset --hard

printf "${YELLOW}Cleaning main repo...\n${DEFAULT}"
git clean -f -d -x

printf "${YELLOW}Pulling latest main repo changes...\n${DEFAULT}"
git fetch origin
git reset --hard origin/master

printf "${YELLOW}Reseting submodules...\n${DEFAULT}"
git submodule foreach --recursive git reset --hard

printf "${YELLOW}Cleaning submodules...\n${DEFAULT}"
git submodule foreach --recursive git clean -f -d -x

printf "${YELLOW}Pulling latest submodules changes...\n${DEFAULT}"
git submodule update --init --recursive --remote