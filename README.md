# cakeup

A binary bootstrapper for Cake.  
This application will do things like:  

* Install Cake
* Install NuGet.exe
* Install dotnet SDK
* Bootstrap modules
* Execute script

## Usage

```
Usage: cakeup [--cake=<VERSION>] [--script=<SCRIPT>]
              [--nuget=<VERSION>] [--sdk=<VERSION>]
              [--coreclr] [--bootstrap] [-- ARGUMENTS]

  --cake   <VERSION>  The version of Cake to install.
  --script <SCRIPT>   The script to execute.
  --nuget  <VERSION>  The version of NuGet to install.
  --sdk    <VERSION>  The version of the dotnet SDK to install.
  --coreclr           Use CoreCLR version of Cake.
  --bootstrap         Bootstraps Cake modules.
  --execute           Executes the Cake script.
  --version           Prints version information.
  --help              Prints help information.
```

You can also set parameters to cakeup via the following
environment variables. Note that this does not override
parameters directly to cakeup.

```
CAKEUP_CAKE       = "0.24.0"
CAKEUP_SCRIPT     = "test.cake"
CAKEUP_NUGET      = "latest"
CAKEUP_SDK        = "1.1.7"
CAKEUP_EXECUTE    = "true"
CAKEUP_CORECLR    = "true"
CAKEUP_BOOTSTRAP  = "true"
```

## Example

Install CoreCLR version of Cake 0.25.0.
Also install version 1.1.7 of the dotnet SDK.

```
> ./cakeup.exe --cake=0.24.0 --sdk=1.1.7 --coreclr --bootstrap

Creating tools directory...
Downloading Cake.CoreClr 0.24.0...
Unzipping binaries...
Creating .dotnet directory...
Downloading .NET Core SDK installation script...
Installing .NET Core SDK...
Bootstrapping build.cake...
Done!
```