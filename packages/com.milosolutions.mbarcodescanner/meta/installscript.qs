function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDirDest@/@ProjectName@");
    component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mbarcodescanner/.git");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mbarcodescanner/.gitignore");
	component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/milo/mbarcodescanner/.gitlab-ci.yml");
	installer.setValue("postOperations", "true");
}
