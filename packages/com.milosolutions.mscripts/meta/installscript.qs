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
    component.addOperation("LineReplace", "@TargetDir@/@ProjectName@/milo/mscripts/version/bumpVersion.sh", "TEMPLATE_PROJECT_NAME", "TEMPLATE_PROJECT_NAME=\"@ProjectName@\"");
	component.addOperation("LineReplace", "@TargetDir@/@ProjectName@/milo/mscripts/version/bumpVersion.bat", "set TEMPLATE_PROJECT_NAME", "set TEMPLATE_PROJECT_NAME=@ProjectName@");
	if (installer.value("startMenu", "") == "" && systemInfo.productType == "windows")
	{
		component.addOperation("CreateShortcut", "@TargetDir@/maintenancetool.exe", "@StartMenuDir@/maintenancetool.lnk",
            "workingDirectory=@TargetDir@", "iconPath=%SystemRoot%/system32/SHELL32.dll",
            "iconId=2");
	}
}
