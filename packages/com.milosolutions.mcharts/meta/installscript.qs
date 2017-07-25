function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDir@/@ProjectName@");
    component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mcharts/.git");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mcharts/.gitignore");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mcharts/.gitlab-ci.yml");
}
