function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDir@/@ProjectName@");
    component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mconfig/.git");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mconfig/.gitignore");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mconfig/.gitlab-ci.yml");
}
