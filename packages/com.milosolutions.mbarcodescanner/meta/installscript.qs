function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDir@/@ProjectName@");
    component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mbarcodescanner/.git");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mbarcodescanner/.gitignore");
	component.addOperation("Delete", "@TargetDir@/@ProjectName@/milo/mbarcodescanner/.gitlab-ci.yml");
}
