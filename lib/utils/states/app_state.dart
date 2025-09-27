/// Generic state management class for handling loading, data, and error states
class AppState<T> {
  final bool isLoading;
  final T? data;
  final String? errorMessage;
  final bool hasError;
  
  const AppState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
    this.hasError = false,
  });
  
  /// Initial state
  static AppState<T> initial<T>() => AppState<T>();
  
  /// Loading state
  static AppState<T> loading<T>() => AppState<T>(isLoading: true);
  
  /// Success state with data
  static AppState<T> success<T>(T data) => AppState<T>(
    data: data,
    isLoading: false,
  );
  
  /// Error state
  static AppState<T> errorState<T>(String error) => AppState<T>(
    errorMessage: error,
    hasError: true,
    isLoading: false,
  );
  
  /// Copy with method for immutable updates
  AppState<T> copyWith({
    bool? isLoading,
    T? data,
    String? errorMessage,
    bool? hasError,
  }) {
    return AppState<T>(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
    );
  }
  
  /// Helper getters
  bool get isInitial => !isLoading && data == null && !hasError;
  bool get isSuccess => !isLoading && data != null && !hasError;
  bool get isError => hasError && errorMessage != null;
  
  @override
  String toString() {
    return 'AppState(isLoading: $isLoading, hasError: $hasError, errorMessage: $errorMessage, data: $data)';
  }
}
