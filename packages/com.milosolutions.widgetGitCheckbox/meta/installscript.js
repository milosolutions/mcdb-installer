function Component() { 
    if (installer.isInstaller()) { 
        component.loaded.connect(this, Component.prototype.installerLoaded); 
    } 
} 
 
Component.prototype.installerLoaded = function () { 
	console.log("Setting up git checkbox widget") 
    if (installer.addWizardPageItem(component, "gitCheckboxWidget", QInstaller.TargetDirectory)) { 
        var widget = gui.findChild(gui.pageById(QInstaller.TargetDirectory), "gitCheckboxWidget"); 
        if (widget != null) { 
			widget.gitCheckbox.toggled.connect(this, Component.prototype.onCheckboxToggled); 
        } 
    } 
} 
 
Component.prototype.onCheckboxToggled = function (toggled) {   
	installer.setValue("git", toggled ? "true" : "false");
}