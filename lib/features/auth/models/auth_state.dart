class AuthState {
  final bool isAuthenticated;
  final String? token;
  final DateTime? tokenExpiry;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.tokenExpiry,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    DateTime? tokenExpiry,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      tokenExpiry: tokenExpiry ?? this.tokenExpiry,
      error: error ?? this.error,
    );
  }
}
