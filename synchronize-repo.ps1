<#
	Use it to synchonize this repository and all submodules contained in it on Windows.

	IMPORTANT! ------------------------------------------
	* Do not change anything!
	-----------------------------------------------------

	Author: 	SWANN
	Email:		sebastianswann@outlook.com

	LICENSE ------------------------------------------

	Copyright (c) 2016-2018 SWANN
	All rights reserved.

	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

	1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	3. The names of the contributors may not be used to endorse or promote products derived from this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

<# -----------------------------------------------------------------
DEFAULTS                                                           |
----------------------------------------------------------------- #>

# clear console
Clear-Host

# this script path
$this = (Split-Path -Parent ($MyInvocation.MyCommand.Path))

<# -----------------------------------------------------------------
HELPERS                                                            |
----------------------------------------------------------------- #>

function Write-ErrorMessage
{ 
	param
	(
		[Parameter(Mandatory=$true)] 
		[System.Management.Automation.Host.PSHost] $App,
		
		[Parameter(Mandatory=$true)]
		[string] $ErrorMessage,
		
		[string] $Message
	)
	
	
	if ($ErrorMessage.Length -gt 0) { Write-Host $ErrorMessage -ForegroundColor Red }
	if ($Message.Length -gt 0) { Write-Host $Message }
	
	Write-Host "Press any key to continue ..."
	$App.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
}

<# -----------------------------------------------------------------
MAIN                                                               |
----------------------------------------------------------------- #>

# make sure we have GIT shell available
try
{ & git --version | Out-Null }
catch [System.Management.Automation.CommandNotFoundException]
{
	Write-ErrorMessage -App $host -ErrorMessage 'Git support seems to be unavailable.' -Message ("Make sure that you have downloaded and installed:`n- Git Shell extension: {0}`n- Git LFS extension: {1}" -f 'https://git-scm.com/', 'https://git-lfs.github.com/')
	return
}

# make sure we have GIT LFS available
try
{ & git lfs version | Out-Null }
catch [System.Management.Automation.CommandNotFoundException]
{
	Write-ErrorMessage -App $host -ErrorMessage 'Git LFS support seems to be unavailable.' -Message ("Make sure that you have downloaded and installed:`n- Git LFS extension: {0}" -f 'https://git-lfs.github.com/')
	return
}

# execute GIT commands
cd $this

Write-Host 'Reseting main repo...' -ForegroundColor Yellow
& git reset --hard

Write-Host 'Cleaning main repo...' -ForegroundColor Yellow
& git clean -f -d -x

Write-Host 'Pulling latest main repo changes...' -ForegroundColor Yellow
& git fetch origin
& git reset --hard origin/master

Write-Host 'Reseting submodules...' -ForegroundColor Yellow
& git submodule foreach --recursive git reset --hard

Write-Host 'Cleaning submodules...' -ForegroundColor Yellow
& git submodule foreach --recursive git clean -f -d -x

Write-Host 'Pulling latest submodules changes...' -ForegroundColor Yellow
& git submodule update --init --recursive --remote