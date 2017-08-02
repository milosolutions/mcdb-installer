function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDirDest@/@ProjectName@");
    component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mcharts/.git");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mcharts/.gitignore");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mcharts/.gitlab-ci.yml");
	installer.setValue("postOperations", "true");
}
