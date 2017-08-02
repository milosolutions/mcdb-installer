function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDirDest@/@ProjectName@");
    component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mcrypto/.git");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mcrypto/.gitignore");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mcrypto/.gitlab-ci.yml");
	installer.setValue("postOperations", "true");
}