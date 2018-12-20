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
	installer.setValue("postOperations", "true");
}
