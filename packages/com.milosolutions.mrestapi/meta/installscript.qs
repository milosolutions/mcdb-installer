function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDir@/@ProjectName@");
    component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mrestapi/.git");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mrestapi/.gitignore");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mrestapi/tst_mrestapi/.gitignore");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mrestapi/.gitlab-ci.yml");
}
