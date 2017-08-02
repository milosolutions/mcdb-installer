var widgetName = "GitOptionsWidget";

function Component() {
    if (installer.isInstaller()) {
        installer.valueChanged.connect(this, Component.prototype.onAddPageChanged);
    }
}

Component.prototype.addGit = function()
{

}

Component.prototype.onAddPageChanged = function (key, value) {
	if (key == "git") {
		if (value == "true") {
			if (installer.addWizardPage(component, widgetName, QInstaller.ComponentSelection)) {
				var widget = gui.pageWidgetByObjectName("Dynamic"+widgetName);
				if (widget != null) {
					widget.gitRemote.textChanged.connect(this, Component.prototype.gitRemoteChanged);
					widget.initCommitCheckbox.toggled.connect(this, Component.prototype.initCommitCheckboxToggled);
					widget.commitAllFilesCheckbox.toggled.connect(this, Component.prototype.commitAllFilesCheckboxToggled);
					widget.windowTitle = "Git repository options";
					widget.gitRemote.text = "";
					installer.setValue("git-commit", "true");
				}
			}
		}
		else if (gui.pageWidgetByObjectName("Dynamic"+widgetName) != null)
		{
			installer.removeWizardPage(component, widgetName);
		}
	}
}

Component.prototype.initCommitCheckboxToggled = function (toggle) {
    installer.setValue("git-commit", toggle ? "true" : "false");
}

Component.prototype.commitAllFilesCheckboxToggled = function (toggle) {
    installer.setValue("git-commit-all", toggle ? "true" : "false");
}

Component.prototype.gitRemoteChanged = function (text) {
	installer.setValue("git-remote", text.trim());
}