function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDirDest@/@ProjectName@");
    component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mrestapi/.git");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mrestapi/.gitignore");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mrestapi/tst_mrestapi/.gitignore");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mrestapi/.gitlab-ci.yml");
}
