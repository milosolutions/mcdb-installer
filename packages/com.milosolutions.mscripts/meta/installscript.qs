function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDir@/@ProjectName@");
    component.addOperation("Delete", "@TargetDir@/@ProjectName@/ci-build-scripts/.git");
}

Component.prototype.createOperations = function()
{
    // call default implementation
    component.createOperations();
    component.addOperation("Replace", "@TargetDir@/@ProjectName@/milo/mscripts/bumpVersion.sh", "template", "@ProjectName@");
}
