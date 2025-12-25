import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mysivi_chat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:mysivi_chat/features/users/data/models/user_model.dart';
import '../network/api_client.dart';
import '../../features/users/data/user_repository.dart';
import '../../features/chat/data/chat_repository.dart';
import '../../features/history/data/history_repository.dart';
import '../../features/users/presentation/bloc/user_bloc.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => ApiClient(sl()));

  // Repositories
  sl.registerLazySingleton(() => UserRepository());
  sl.registerLazySingleton(() => ChatRepository(sl()));
  sl.registerLazySingleton(() => HistoryRepository());

  // Blocs
  sl.registerLazySingleton(() => UserBloc(sl()));
  sl.registerLazySingleton(() => HistoryBloc(sl()));
  sl.registerFactoryParam<ChatBloc, UserModel, void>(
    (user, _) => ChatBloc(chatRepository: sl(), historyBloc: sl()),
  );
}
