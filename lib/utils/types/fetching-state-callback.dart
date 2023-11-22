enum FetchingState { done, waiting, faliure }

typedef FetchingStateCallback = Function({required FetchingState state, dynamic error});
