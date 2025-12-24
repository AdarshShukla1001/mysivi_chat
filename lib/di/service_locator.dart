import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../features/chat/data/datasources/local/local_message_data_source.dart';
import '../features/chat/data/datasources/remote/receiver_message_remote_data_source.dart';
import '../features/chat/data/repositories/chat_repository_impl.dart';
import '../features/chat/domain/repositories/chat_repository.dart';

import '../features/chat/presentation/bloc/chat_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Chat
  // Bloc
  sl.registerFactory<ChatBloc>(
    () => ChatBloc(chatRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ReceiverMessageRemoteDataSource>(
    () => ReceiverMessageRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<LocalMessageDataSource>(
    () => LocalMessageDataSourceImpl(),
  );

  // Core
  sl.registerLazySingleton(() => http.Client());
}
