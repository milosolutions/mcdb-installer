function Component() {
    if (installer.isInstaller()) {
        component.loaded.connect(this, Component.prototype.installerLoaded);
        console.log("Connecting installer loaded");
    }
}

Component.prototype.installerLoaded = function () {
    if (installer.addWizardPage(component, "ProjectNameWidget", QInstaller.TargetDirectory)) {
        console.log("Setting up project name widget 1");
        var widget = gui.pageWidgetByObjectName("DynamicProjectNameWidget");
        if (widget != null) {
            console.log("Setting up project name widget 2");
            widget.projectName.textChanged.connect(this, Component.prototype.projectNameChanged);
            widget.windowTitle = "Project name";
            widget.projectName.text = "default";
        }
    }
}

Component.prototype.projectNameChanged = function (text) {
    var widget = gui.pageWidgetByObjectName("DynamicProjectNameWidget");
    if (widget != null) {
        if (text != "") {
            console.log("Project name changed to:" + text);
            widget.complete = true;
            installer.setValue("ProjectName", text);
            return;
        }
        widget.complete = false;
    }
}