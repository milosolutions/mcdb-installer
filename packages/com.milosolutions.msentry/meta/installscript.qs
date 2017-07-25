function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDir@/@ProjectName@");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/msentry/.git");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/msentry/.gitignore");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/msentry/.gitlab-ci.yml");
}