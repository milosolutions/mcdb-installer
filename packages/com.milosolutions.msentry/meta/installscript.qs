function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDir@/@ProjectName@");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/msentry/.git");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/msentry/.gitignore");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/msentry/.gitlab-ci.yml");
	if (installer.value("startMenu", "") == "" && systemInfo.productType == "windows")
	{
		component.addOperation("CreateShortcut", "@TargetDir@/maintenancetool.exe", "@StartMenuDir@/maintenancetool.lnk",
            "workingDirectory=@TargetDir@", "iconPath=%SystemRoot%/system32/SHELL32.dll",
            "iconId=2");
	}
}