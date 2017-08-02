function Controller()
{
    installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false);
    installer.setMessageBoxAutomaticAnswer("OverwriteTargetDirectory", QMessageBox.Yes);
	installer.valueChanged.connect(this, Controller.prototype.onValueChanged);
}

Controller.prototype.onValueChanged = function(key, value)
{
	if (key == "postOperations")
	{
		postOperations();
	}
}

function postOperations()
{
	if( installer.isInstaller() ) {
		var components = installer.components();
		for(var i = components.length - 1 ; i >= 0 ; i--) {
			if( components[i].installationRequested() ) {
				if (installer.value("git", "false") == "true")
				{
					if (systemInfo.productType == "windows")
					{
						// Creating README file
						components[i].addOperation("Execute", "cmd", "/C", "echo. >README.md", "workingdirectory=@TargetDirDest@/@ProjectName@", "errormessage=Could not find git!");
						components[i].addOperation("Execute", "cmd", "/C", "git init", "workingdirectory=@TargetDirDest@/@ProjectName@", "errormessage=Could not find git!");
						if (installer.value("git-commit", "false") == "true")
						{
							if (installer.value("git-commit-all", "false"))
								components[i].addOperation("Execute", "cmd", "/C", "git add --all", "workingdirectory=@TargetDirDest@/@ProjectName@", "errormessage=Could not add unstaged files!");
							else
								components[i].addOperation("Execute", "cmd", "/C", "git add README.md", "workingdirectory=@TargetDirDest@/@ProjectName@", "errormessage=Could not add unstaged files!");
							components[i].addOperation("Execute", "cmd", "/C", "git commit -m", "Init_commit", "workingdirectory=@TargetDirDest@/@ProjectName@", "errormessage=Could not create commit!");
							
							if (installer.value("git-remote","") != "")
								components[i].addOperation("Execute", "cmd", "/C", "git remote add origin", installer.value("git-remote"), "workingdirectory=@TargetDirDest@/@ProjectName@", "errormessage=Could not create commit!");
						}
					}
					else
					{
						// Creating README file
						components[i].addOperation("Execute", "touch", "README.md", "workingdirectory=@TargetDirDest@/@ProjectName@", "errormessage=Could not find git!");
						components[i].addOperation("Execute", "git", "init", "workingdirectory=@TargetDirDest@/@ProjectName@", "errormessage=Could not find git!");
						if (installer.value("git-commit", "false") == "true")
						{
							if (installer.value("git-commit-all", "false"))
								components[i].addOperation("Execute", "git", "add", "--all", "workingdirectory=@TargetDirDest@/@ProjectName@", "errormessage=Could not find git!");
							else
								components[i].addOperation("Execute", "git", "add", "README.md", "workingdirectory=@TargetDirDest@/@ProjectName@", "errormessage=Could not find git!");
							components[i].addOperation("Execute", "git", "commit", "-m", "Init_commit", "workingdirectory=@TargetDirDest@/@ProjectName@", "errormessage=Could not create commit!");
							
							if (installer.value("git-remote","") != "")
								components[i].addOperation("Execute", "git", "remote", "add", "origin", installer.value("git-remote"), "workingdirectory=@TargetDirDest@/@ProjectName@", "errormessage=Could not create commit!");
						}
					}
					installer.setValue("git", "false");
				}
				return;
			}
		}
	}
}

Controller.prototype.ComponentSelectionPageCallback = function()
{
    installer.setValue("TargetDirDest" , installer.value("TargetDir"));
    installer.setValue("TargetDir", QDesktopServices.storageLocation(QDesktopServices.TempLocation)+"/tmptmp");
}