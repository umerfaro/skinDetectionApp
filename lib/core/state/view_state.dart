// UI State enumeration
enum ViewState { idle, loading, success, error }

// Loading state types
enum LoadingType { initial, refresh, loadMore, action }

// Generic view state wrapper
class ViewStateWrapper<T> {
  final ViewState state;
  final T? data;
  final String? errorMessage;
  final LoadingType loadingType;

  const ViewStateWrapper({
    required this.state,
    this.data,
    this.errorMessage,
    this.loadingType = LoadingType.initial,
  });

  // Factory constructors
  factory ViewStateWrapper.idle() {
    return const ViewStateWrapper(state: ViewState.idle);
  }

  factory ViewStateWrapper.loading([LoadingType type = LoadingType.initial]) {
    return ViewStateWrapper(state: ViewState.loading, loadingType: type);
  }

  factory ViewStateWrapper.success(T data) {
    return ViewStateWrapper(state: ViewState.success, data: data);
  }

  factory ViewStateWrapper.error(String message) {
    return ViewStateWrapper(state: ViewState.error, errorMessage: message);
  }

  // Convenience getters
  bool get isIdle => state == ViewState.idle;
  bool get isLoading => state == ViewState.loading;
  bool get isSuccess => state == ViewState.success;
  bool get isError => state == ViewState.error;
  bool get hasData => data != null;

  // Copy with method
  ViewStateWrapper<T> copyWith({
    ViewState? state,
    T? data,
    String? errorMessage,
    LoadingType? loadingType,
  }) {
    return ViewStateWrapper<T>(
      state: state ?? this.state,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      loadingType: loadingType ?? this.loadingType,
    );
  }

  @override
  String toString() {
    return 'ViewStateWrapper(state: $state, hasData: $hasData, errorMessage: $errorMessage)';
  }
}
