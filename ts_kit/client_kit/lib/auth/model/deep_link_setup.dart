class DeepLinkSetup {
  final String appDomain;
  final String androidPackageName;
  final String iOSBundleId;
  final String? linkPrefix;
  final String linkDomain;
  final bool androidPromptInstallApp;

  DeepLinkSetup({
    required this.appDomain,
    required this.androidPackageName,
    required this.iOSBundleId,
    required this.linkPrefix,
    required this.linkDomain,
    required this.androidPromptInstallApp,
  });
}
