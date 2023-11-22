import 'package:evira/utils/types/fetching-state-callback.dart';

typedef DataCallback<T> = void Function(T data, FetchingState fetchingState);
