function Component() {
    if (installer.isInstaller()) {
        component.loaded.connect(this, Component.prototype.installerLoaded);
    }
}

Component.prototype.installerLoaded = function () {
	console.log("Setting up project skip button widget 1")
    if (installer.addWizardPageItem(component, "skipButton", QInstaller.StartMenuSelection)) {
        var widget = gui.findChild(gui.pageById(QInstaller.StartMenuSelection), "skipButton");
        if (widget != null) {
			console.log("Setting up project skip button widget 2")
			widget.pushButton.pressed.connect(this, Component.prototype.onSkipButtonClicked);
        }
    }
}

Component.prototype.onSkipButtonClicked = function () {	
	installer.setValue("startMenu", "false");
	gui.clickButton(buttons.NextButton, 1);
}