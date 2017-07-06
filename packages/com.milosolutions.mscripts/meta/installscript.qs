function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDir@/@ProjectName@");
    component.addOperation("Delete", "@TargetDir@/@ProjectName@/ci-build-scripts/.git");
}

Component.prototype.createOperations = function()
{
    // call default implementation
    component.createOperations();
    component.addOperation("Replace", "@TargetDir@/@ProjectName@/milo/mscripts/version/bumpVersion.sh", "template", "@ProjectName@");
	if (installer.value("startMenu", "") == "")
	{
		installer.setValue("startMenu", "");
		component.addOperation("CreateShortcut", "@TargetDir@/maintenancetool.exe", "@StartMenuDir@/maintenancetool.lnk",
            "workingDirectory=@TargetDir@", "iconPath=%SystemRoot%/system32/SHELL32.dll",
            "iconId=2");
	}
}
