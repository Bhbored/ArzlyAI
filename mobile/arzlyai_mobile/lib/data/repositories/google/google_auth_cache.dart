class GoogleAuthCache {
  const GoogleAuthCache({
    required this.accountEmail,
    this.accountDisplayName,
    this.authorizedConnectors = const {},
  });

  final String accountEmail;
  final String? accountDisplayName;
  final Set<String> authorizedConnectors;
}
