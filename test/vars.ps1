# Script that sets some variables used in the GitHub Action steps

param (
    [Parameter(Mandatory = $true)]
    [ValidateSet(32, 64)]
    [int] $Bits
)

$cygwinPackages = 'autoconf,automake,autotools,bison,gettext-devel,gperf,libtool,make,patch,python3'

switch ($Bits) {
    32 {
        $cygwinPackages = "$cygwinPackages,mingw64-i686-gcc-core,mingw64-i686-gcc-g++,mingw64-i686-headers,mingw64-i686-runtime"
        $mingwHost = 'i686-w64-mingw32'
    }
    64 {
        $cygwinPackages = "$cygwinPackages,mingw64-x86_64-gcc-core,mingw64-x86_64-gcc-g++,mingw64-x86_64-headers,mingw64-x86_64-runtime"
        $mingwHost = 'x86_64-w64-mingw32'
    }
}

$configureArgs = @(
    "--host=$mingwHost",
    '--enable-relocatable',
    '--config-cache',
    '--disable-dependency-tracking',
    '--enable-nls',
    '--disable-rpath',
    '--disable-acl',
    '--enable-threads=windows'
)

"cygwin-packages=$cygwinPackages" | Out-File -FilePath $env:GITHUB_OUTPUT -Append -Encoding utf8
"cygwin-path=/installed/bin:/usr/$mingwHost/bin:/usr/$mingwHost/sys-root/mingw/bin:/usr/sbin:/usr/bin:/sbin:/bin:/cygdrive/c/Windows/system32:/cygdrive/c/Windows" | Out-File -FilePath $env:GITHUB_OUTPUT -Append -Encoding utf8
"mingw-host=$mingwHost" | Out-File -FilePath $env:GITHUB_OUTPUT -Append -Encoding utf8
"configure-args=$configureArgs" | Out-File -FilePath $env:GITHUB_OUTPUT -Append -Encoding utf8
"cpp-flags=-I/usr/$mingwHost/sys-root/mingw/include" | Out-File -FilePath $env:GITHUB_OUTPUT -Append -Encoding utf8
"ld-flags=-L/usr/$mingwHost/sys-root/mingw/lib" | Out-File -FilePath $env:GITHUB_OUTPUT -Append -Encoding utf8
Write-Output '## Outputs'
Get-Content $env:GITHUB_OUTPUT
