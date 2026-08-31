class GoogleAuthorizationInteractionRequired implements Exception {
  const GoogleAuthorizationInteractionRequired([
    this.message = 'Google authorization requires reopening the app.',
  ]);

  final String message;

  @override
  String toString() => message;
}

class GoogleAccountRequired implements Exception {
  const GoogleAccountRequired([
    this.message = 'Sign in to Google in Settings first.',
  ]);

  final String message;

  @override
  String toString() => message;
}
