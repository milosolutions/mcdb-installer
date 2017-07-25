function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDirDest@/@ProjectName@");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/msentry/.git");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/msentry/.gitignore");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/msentry/.gitlab-ci.yml");
}