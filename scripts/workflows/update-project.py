import sys
from unityparser import UnityDocument

# Force a specific bundle id and set Mono (0) or IL2CPP (1) for desktop
# Also set the build number for iOS / macOS

project_settings_file = sys.argv[1] + '/ProjectSettings/ProjectSettings.asset'
doc = UnityDocument.load_yaml(project_settings_file)
ProjectSettings = doc.entry
ProjectSettings.applicationIdentifier["iPhone"] = sys.argv[2]
ProjectSettings.applicationIdentifier["Standalone"] = sys.argv[3]
ProjectSettings.applicationIdentifier["Android"] = sys.argv[4]

ProjectSettings.scriptingBackend["Standalone"] = sys.argv[5]

ProjectSettings.buildNumber["Standalone"] = sys.argv[6]
ProjectSettings.buildNumber["iPhone"] = sys.argv[6]

doc.dump_yaml()