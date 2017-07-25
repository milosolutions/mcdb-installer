function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDir@/@ProjectName@");
    component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mcrypto/.git");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mcrypto/.gitignore");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mcrypto/.gitlab-ci.yml");
}