function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDir@/@ProjectName@");
}

Component.prototype.createOperations = function()
{
    // call default implementation
    component.createOperations();

    // Custom operations:
    //   - Rename template files to use the project name
    //   - Add license file (same as component license)
    //   - Remove .pro.user file - if present
    //   - Remove .gitlab-ci.yml file
    component.addOperation("Move", "@TargetDir@/@ProjectName@/newprojecttemplate.doxyfile", "@TargetDir@/@ProjectName@/@ProjectName@.doxyfile");
    component.addOperation("Move", "@TargetDir@/@ProjectName@/template.doxytag", "@TargetDir@/@ProjectName@/@ProjectName@.doxytag");
    component.addOperation("Move", "@TargetDir@/@ProjectName@/template.pro", "@TargetDir@/@ProjectName@/@ProjectName@.pro");
    //component.addOperation("Copy", "@TargetDir@/../Licenses/license.txt", "@TargetDir@/@ProjectName@/license.txt");
    component.addOperation("Delete", "@TargetDir@/@ProjectName@/template.pro.user");
    component.addOperation("Delete", "@TargetDir@/@ProjectName@/.gitlab-ci.yml");
    component.addOperation("Move", "@TargetDir@/@ProjectName@/.gitlab-ci.yml.example", "@TargetDir@/@ProjectName@/.gitlab-ci.yml");

    // find and replace all occurrences of the word Template / template to "@ProjectName@"
    component.addOperation("Replace", "@TargetDir@/@ProjectName@/src/src.pro", "Template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDir@/@ProjectName@/src/src.pro", "template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDir@/@ProjectName@/@ProjectName@.doxyfile", "Template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDir@/@ProjectName@/@ProjectName@.doxyfile", "template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDir@/@ProjectName@/src/main.cpp", "Template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDir@/@ProjectName@/src/main.cpp", "template", "@ProjectName@");

    // retrieve all installation requested components and in depends on kind of
    // component ( module / platform support ) perform the appropriate action.
    try {
        if( installer.isInstaller() ) {
            var components = installer.components();
            console.log("Retrieve installation requested components...");

            for( i in components ) {
                if( components[i].installationRequested() ) {

                    switch( components[i].name ) {
                        // if component applies to module
                        case "com.milosolutions.mconfig"           :
                        case "com.milosolutions.mlog"              :
                        case "com.milosolutions.msentry"           :
                        case "com.milosolutions.mcharts"           :
                        case "com.milosolutions.mrestapi"          :
                        case "com.milosolutions.mbarcodescanner"   :
                        case "com.milosolutions.mcharts"           :
                            appendComponent( components[i] );
                        break;

                        // if component applies to platform support
                        case "com.milosolutions.newprojecttemplate.platforms.windows" :
                            component.setValue("platform-windows", "added");
                            appendPlatformSupport( components[i] );
                        break;
                        case "com.milosolutions.newprojecttemplate.platforms.mac"     :
                            component.setValue("platform-mac", "added");
                            appendPlatformSupport( components[i] );
                        break;
                        case "com.milosolutions.newprojecttemplate.platforms.android" :
                            component.setValue("platform-android", "added");
                            appendPlatformSupport( components[i] );
                        break;
                    }
                }
            }
        }
    } catch(e) {
        console.log(e);
    }

    // Cannot delete directory from external drive on windows
    // https://bugreports.qt.io/browse/QTIFW-842
    if (systemInfo.productType != "windows")
    {
      if (component.value("platform-windows", "") == "")
          component.addOperation("Delete", "@TargetDir@/@ProjectName@/platforms/windows");
      if (component.value("platform-mac", "") == "")
          component.addOperation("Delete", "@TargetDir@/@ProjectName@/platforms/mac");
      if (component.value("platform-android", "") == "")
          component.addOperation("Delete", "@TargetDir@/@ProjectName@/platforms/android");
    }
	else
	if (installer.value("startMenu", "") == "")
	{
		installer.setValue("startMenu", "");
		component.addOperation("CreateShortcut", "@TargetDir@/maintenancetool.exe", "@StartMenuDir@/maintenancetool.lnk",
            "workingDirectory=@TargetDir@", "iconPath=%SystemRoot%/system32/SHELL32.dll",
            "iconId=2");
	}
}

function appendComponent(component) {
    var componentName = component.name.split(".").pop();
    component.addOperation("Replace", "@TargetDir@/@ProjectName@/src/src.pro",
                           "## Modules",
                           "## Modules" + "\n" +
                            "include(../milo/" + componentName + "/" + componentName + ".pri)");

    // if component has test
    switch (component.name) {
        case "com.milosolutions.mconfig"  :
        case "com.milosolutions.mlog"     :
        case "com.milosolutions.mrestapi" :
                appendComponentTest(component);
        break;
    }
    
    console.log("Installed component: " + componentName);
}

function appendComponentTest(component) {
    var componentName = component.name.split(".").pop();
    
    component.addOperation("Replace", "@TargetDir@/@ProjectName@/tests/tests.pro",
                           "SUBDIRS += \\",
                           "SUBDIRS += \\" + "\n" +
                           "\t../milo/" + componentName + "/tst_" + componentName + " \\");
}

function appendPlatformSupport(component) {

    var componentName = component.name.split(".").pop();
    component.addOperation("Replace", "@TargetDir@/@ProjectName@/src/src.pro",
                           "## Platforms",
                           "## Platforms" + "\n" +
                            "include(../platforms/" + componentName + "/" + componentName + ".pri)");

    component.addOperation("Replace",
        "@TargetDir@/@ProjectName@/platforms/" + componentName + "/" + componentName + ".pri",
                           "template", "@ProjectName@");

    console.log("Platform support: " + componentName );
}
