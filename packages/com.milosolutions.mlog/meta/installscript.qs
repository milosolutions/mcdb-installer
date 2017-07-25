function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDir@/@ProjectName@");
    component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mlog/.git");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mlog/.gitignore");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mlog/.gitlab-ci.yml");
}