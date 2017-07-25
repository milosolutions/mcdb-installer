function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDirDest@/@ProjectName@");
    component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mconfig/.git");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mconfig/.gitignore");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mconfig/.gitlab-ci.yml");
}
