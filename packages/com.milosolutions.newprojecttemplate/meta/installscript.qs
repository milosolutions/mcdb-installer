var lastModuleLine = "## Modules";

function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.addOperation("Extract", archive, "@TargetDirDest@/@ProjectName@");
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
    component.addOperation("Move", "@TargetDirDest@/@ProjectName@/newprojecttemplate.doxyfile", "@TargetDirDest@/@ProjectName@/@ProjectName@.doxyfile");
    component.addOperation("Move", "@TargetDirDest@/@ProjectName@/template.pro", "@TargetDirDest@/@ProjectName@/@ProjectName@.pro");
    //component.addOperation("Copy", "@TargetDirDest@/../Licenses/license.txt", "@TargetDirDest@/@ProjectName@/license.txt");
    component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/template.pro.user");
    component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/template.doxytag");
    component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/.gitlab-ci.yml");
    component.addOperation("Move", "@TargetDirDest@/@ProjectName@/gitlab-ci.yml.example", "@TargetDirDest@/@ProjectName@/.gitlab-ci.yml");
    component.addOperation("Move", "@TargetDirDest@/@ProjectName@/gitignore.example", "@TargetDirDest@/@ProjectName@/.gitignore");

    // find and replace all occurrences of the word Template / template to "@ProjectName@"
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/src/src.pro", "Template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/src/src.pro", "template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/@ProjectName@.doxyfile", "Template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/@ProjectName@.doxyfile", "template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/src/main.cpp", "Template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/src/main.cpp", "template", "@ProjectName@");

    // retrieve all installation requested components and in depends on kind of
    // component ( module / platform support ) perform the appropriate action.
    try {
        if( installer.isInstaller() ) {
            var components = installer.components();

            for( i in components ) {
                if( components[i].installationRequested() ) {
                    console.log("Retrieve installation requested components..." + components[i].name);

                    switch( components[i].name ) {
                        // if component applies to module
						case "com.milosolutions.mscripts"          :
						    var componentName = components[i].name.split(".").pop();
                            components[i].addOperation("Replace", "@TargetDirDest@/@ProjectName@/src/src.pro",
                            "## Modules",
                            "## Modules" + "\n" +
							"include(../milo/" + componentName + "/version/version.pri)");
						break;
                        case "com.milosolutions.mconfig"           :
                        case "com.milosolutions.mlog"              :
                        case "com.milosolutions.msentry"           :
                        case "com.milosolutions.mrestapi"          :
                        case "com.milosolutions.mbarcodescanner"   :
                        case "com.milosolutions.mcharts"           :
						case "com.milosolutions.mcrypto"           :
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
          component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/platforms/windows");
      if (component.value("platform-mac", "") == "")
          component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/platforms/mac");
      if (component.value("platform-android", "") == "")
          component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/platforms/android");
    }
}

function appendComponent(component) {
    var componentName = component.name.split(".").pop();
	var includeLine = "include(../milo/" + componentName + "/" + componentName + ".pri)";
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/src/src.pro",
                           lastModuleLine,
                           lastModuleLine + "\n" +
                           includeLine );
						   
	lastModuleLine = includeLine;

    // if component has test
    switch (component.name) {
		case "com.milosolutions.mconfig"           :
		case "com.milosolutions.mlog"              :
		case "com.milosolutions.msentry"           :
		case "com.milosolutions.mrestapi"          :
		case "com.milosolutions.mbarcodescanner"   :
		case "com.milosolutions.mcrypto"           :
		
                appendComponentTest(component);
        break;
    }
    
    console.log("Installed component: " + componentName);
}

function appendComponentTest(component) {
    var componentName = component.name.split(".").pop();
    
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/tests/tests.pro",
                           "SUBDIRS += \\",
                           "SUBDIRS += \\" + "\n" +
                           "\t../milo/" + componentName + "/tst_" + componentName + " \\");
}

function appendPlatformSupport(component) {

    var componentName = component.name.split(".").pop();
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/src/src.pro",
                           "## Platforms",
                           "## Platforms" + "\n" +
                            "include(../platforms/" + componentName + "/" + componentName + ".pri)");

    component.addOperation("Replace",
        "@TargetDirDest@/@ProjectName@/platforms/" + componentName + "/" + componentName + ".pri",
                           "template", "@ProjectName@");

    console.log("Platform support: " + componentName );
}
