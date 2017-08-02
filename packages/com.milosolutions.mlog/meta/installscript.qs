function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDirDest@/@ProjectName@");
    component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mlog/.git");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mlog/.gitignore");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mlog/.gitlab-ci.yml");
	installer.setValue("postOperations", "true");
}