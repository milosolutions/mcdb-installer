#----------------------------------------------------------------------------------------
#
# MILO @ 2016
# Deploy script for Milo Code Database
#
# Dependency:
#       QtInstallerFramework -> https://wiki.milosolutions.com/index.php/Gitlab_CI_runners#Windows_.231
#       doxygen              -> https://wiki.milosolutions.com/index.php/Gitlab_CI_runners#Windows_.231
#       scripts/uploader.ps1
#----------------------------------------------------------------------------------------

[CmdletBinding(PositionalBinding=$false)]
param( 
    [switch]$help 
)

class ScriptArgs {
    # validate script args
    static [void] validate() {
        # check whether -help is set
        if( $script:help -eq $true ) {
            [DeployEngine]::help();
        }
    }
}

class DeployEngine {
    [string] $qtifw = "C:\Tools\QtIFW2.0.3\bin\binarycreator.exe";
    [string] $file = "miloinstaller_"  + (Get-Date).ToString('yyyy.MM.dd') + ".exe";
    [string] $server = "https://seafile.milosolutions.com";
    [string] $repo = $Env:MILOCODEDATABASE_SEAFILE_REPO;
    [string] $user = $Env:MILOVM_SEAFILE_USER;
    [string] $password = $Env:MILOVM_SEAFILE_PASSWORD;
  
    # constructor
    DeployEngine() {
    }
  
    static [void] help() {
        Write-Host( "Usage: scripts/deploy.ps1 [options]" )
        Write-Host "This will only work when invoked from root dir"
        Write-Host ( "Builds all subproject documentation, cleans up build dirs, creates the " +
                   "Milo DB installer and uploads it to Seafile" )
        exit
    }
    
    [void] buildSubmoduleDoc([string] $projectPath) {
        Write-Host "Subproject $projectPath";
        Write-Host "";
        
        $location = $PWD;
        Set-Location -Path $projectPath
        Get-ChildItem -Path ".\" -Filter *.doxyfile -File -Name| ForEach-Object {
            $doxyname = [System.IO.Path]::GetFileNameWithoutExtension($_)
            Write-Host "Doxyname: $doxyname";
            # run doxygen
            &doxygen "$doxyname.doxyfile"
        }
        
        Set-Location -Path $location
    }
  
    [void] buildInstaller() {
        Write-Host "Building Installer..."
        & $this.qtifw -c config/config.xml -p packages $this.file
        Write-Host "Done. `n"
    }
  
    [void] runUploader() {
        Write-Host "Uploading to Seafile..."
        & scripts/uploader.ps1 -f $this.file -s $this.server -r $this.repo -u $this.user -p $this.password
        Write-Host "Done. `n"
    }
  
    [void] run() {
        #build submodules doc
        #$this.buildSubmoduleDoc("packages\com.milosolutions.mbarcodescanner\data\milo\mbarcodescanner");
        #$this.buildSubmoduleDoc("packages\com.milosolutions.mscripts\data\milo\mscripts");
        #$this.buildSubmoduleDoc("packages\com.milosolutions.mcharts\data\milo\mcharts");
        #$this.buildSubmoduleDoc("packages\com.milosolutions.mconfig\data\milo\mconfig");
        #$this.buildSubmoduleDoc("packages\com.milosolutions.mlog\data\milo\mlog");
        #$this.buildSubmoduleDoc("packages\com.milosolutions.mrestapi\data\milo\mrestapi");
		#$this.buildSubmoduleDoc("packages\com.milosolutions.msentry\data\milo\msentry");
		#$this.buildSubmoduleDoc("packages\com.milosolutions.mcrypto\data\milo\mcrypto");
        #$this.buildSubmoduleDoc("packages\com.milosolutions.newprojecttemplate\data");
        
        # Build main docs last - so that they can connect TAGFILES properly
        #$this.buildSubmoduleDoc(".");
        
        # build installer ( QtInstallerFramework )
        $this.buildInstaller();
        
        # run uploader.ps1 script which upload installer to seafile
        $this.runUploader();
    }
}

function main {
    
    # validate script args
    [ScriptArgs]::validate();
    
    # build and upload installer to seafile
    [DeployEngine]::new().run();
}

# main
main
