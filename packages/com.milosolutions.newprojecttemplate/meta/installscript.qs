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
	
	// Changing template directory to project name directory
	if (systemInfo.productType == "windows")
	{
		component.addOperation("Execute", "cmd", "/C", "move template @ProjectName@", "workingdirectory=@TargetDirDest@/@ProjectName@");
	}
	else // Linux
	{
		component.addOperation("Execute", "mv", "template", "@ProjectName@", "workingdirectory=@TargetDirDest@\@ProjectName@");
	}
	
	// Custom operations:
    //   - Rename template files to use the project name
    //   - Remove .pro.user file - if present
    //   - Remove .gitlab-ci.yml file
	//	 - Rename example files
	
    component.addOperation("Move", "@TargetDirDest@/@ProjectName@/newprojecttemplate.doxyfile", "@TargetDirDest@/@ProjectName@/@ProjectName@.doxyfile");
    component.addOperation("Move", "@TargetDirDest@/@ProjectName@/template.pro", "@TargetDirDest@/@ProjectName@/@ProjectName@.pro");
	component.addOperation("Move", "@TargetDirDest@/@ProjectName@/@ProjectName@/template.pro", "@TargetDirDest@/@ProjectName@/@ProjectName@/@ProjectName@.pro");
    component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/template.pro.user");
    component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/template.doxytag");
    component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/.gitlab-ci.yml");
    component.addOperation("Move", "@TargetDirDest@/@ProjectName@/gitlab-ci.yml.example", "@TargetDirDest@/@ProjectName@/.gitlab-ci.yml");
    component.addOperation("Move", "@TargetDirDest@/@ProjectName@/gitignore.example", "@TargetDirDest@/@ProjectName@/.gitignore");
	
	// Tests - replace all occurrences template string with project name
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/tests/tst_project/tst_project.pro", "template", "@ProjectName@");
	component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/tests/tst_project/tst_template.cpp", "Template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/tests/tst_project/tst_template.cpp", "template", "@ProjectName@");
	component.addOperation("Move", "@TargetDirDest@/@ProjectName@/tests/tst_project/tst_template.cpp", "@TargetDirDest@/@ProjectName@/tests/tst_project/tst_@ProjectName@.cpp");

    // find and replace all occurrences of the word Template / template to "@ProjectName@"
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/@ProjectName@/@ProjectName@.pro", "Template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/@ProjectName@/@ProjectName@.pro", "template", "@ProjectName@");
	component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/@ProjectName@.pro", "template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/@ProjectName@.doxyfile", "Template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/@ProjectName@.doxyfile", "template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/@ProjectName@/src/main.cpp", "Template", "@ProjectName@");
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/@ProjectName@/src/main.cpp", "template", "@ProjectName@");

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
                        case "com.milosolutions.newprojecttemplate.platforms.mac"     :
                        case "com.milosolutions.newprojecttemplate.platforms.android" :
                            appendPlatformSupport( components[i] );
                        break;
                    }
                }
            }
        }
    } catch(e) {
        console.log(e);
    }

	
	// Deleting not included platform directories
    // Cannot delete directory from external drive on windows
    // https://bugreports.qt.io/browse/QTIFW-842
    if (systemInfo.productType == "windows")
    {
		if (installer.value("platform-windows", "") == "")
			component.addOperation("Execute", "cmd", "/C", "rd /s /q @TargetDirDest@\\@ProjectName@\\@ProjectName@\\platforms\\windows");
		if (installer.value("platform-mac", "") == "")
			component.addOperation("Execute", "cmd", "/C", "rd /s /q @TargetDirDest@\\@ProjectName@\\@ProjectName@\\platforms\\mac");
		if (installer.value("platform-android", "") == "")
			component.addOperation("Execute", "cmd", "/C", "rd /s /q @TargetDirDest@\\@ProjectName@\\@ProjectName@\\platforms\\android");
    }
	else
	{
		if (installer.value("platform-windows", "") == "")
			component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/@ProjectName@/platforms/windows");
		if (installer.value("platform-mac", "") == "")
			component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/@ProjectName@/platforms/mac");
		if (installer.value("platform-android", "") == "")
			component.addOperation("Delete", "@TargetDirDest@/@ProjectName@/@ProjectName@/platforms/android");
	}
}

function appendComponent(component) {
    var componentName = component.name.split(".").pop();
	var includeLine = "include(../milo/" + componentName + "/" + componentName + ".pri)";
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/@ProjectName@/@ProjectName@.pro",
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
    component.addOperation("Replace", "@TargetDirDest@/@ProjectName@/@ProjectName@/@ProjectName@.pro",
                           "## Platforms",
                           "## Platforms" + "\n" +
                            "include(platforms/" + componentName + "/" + componentName + ".pri)");

    component.addOperation("Replace",
        "@TargetDirDest@/@ProjectName@/@ProjectName@/platforms/" + componentName + "/" + componentName + ".pri",
                           "template", "@ProjectName@");

    installer.setValue("platform-"+componentName, "added");
    console.log("Platform support: " + componentName );
}
