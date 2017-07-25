function Controller()
{
    installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false);
    installer.setMessageBoxAutomaticAnswer("OverwriteTargetDirectory", QMessageBox.Yes);
}

Controller.prototype.ComponentSelectionPageCallback = function()
{
    installer.setValue("TargetDirDest" , installer.value("TargetDir"));
    installer.setValue("TargetDir", QDesktopServices.storageLocation(QDesktopServices.TempLocation));
}
