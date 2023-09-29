#!/bin/bash
#
# ADLMFlexNetServer Entrypoint Script, 2017
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of 
# this software and associated documentation files (the "Software"), to deal in 
# the Software without restriction, including without limitation the rights to 
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
# of the Software, and to permit persons to whom the Software is furnished to do 
# so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
# SOFTWARE.
#

set -e

source utils.sh

# because... life needs more ASCII art
PRINT_LOGO

#visual breakup
PRINT_LINEBREAK

# to help users determine their LMHostID
lmutil lmhostid

#visual breakup
PRINT_LINEBREAK
echo ""

# If no arguments are given, use the license files under /var/flexlm/
if [ "$#" -eq 0 ]; then
    LICENSE_FILES=$(find /var/flexlm/ -type f -print | tr '\n' ':' | sed 's/:$//')
    if [ -z "$LICENSE_FILES" ]; then
        echo "No license files found in /var/flexlm/"
        exit 1
    fi
    # forward the concatenated license files to lmgrd
    lmgrd -z $LICENSE_FILES
else
    # forward all command line arguments to lmgrd
    lmgrd -z $@
fi
