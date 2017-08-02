function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDirDest@/@ProjectName@");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mscripts/.git");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mscripts/.gitignore");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mscripts/.gitlab-ci.yml");
}

Component.prototype.createOperations = function()
{
    // call default implementation
    component.createOperations();
    component.addOperation("LineReplace", "@TargetDirDest@/@ProjectName@/milo/mscripts/version/bumpVersion.sh", "TEMPLATE_PROJECT_NAME", "TEMPLATE_PROJECT_NAME=\"@ProjectName@\"");
	component.addOperation("LineReplace", "@TargetDirDest@/@ProjectName@/milo/mscripts/version/bumpVersion.bat", "set TEMPLATE_PROJECT_NAME", "set TEMPLATE_PROJECT_NAME=@ProjectName@");
	installer.setValue("postOperations", "true");
}
