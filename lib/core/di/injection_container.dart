import 'package:get_it/get_it.dart';
import 'package:mysivi_chat/services/api_service/api_service_imp.dart';
import 'package:mysivi_chat/services/message_db_service/message_db_service.dart';
import 'package:mysivi_chat/services/message_db_service/message_db_service_imp.dart';
import 'package:mysivi_chat/services/user_db_service/user_db_service.dart';
import 'package:mysivi_chat/services/user_db_service/user_db_service_imp.dart';
import 'package:mysivi_chat/services/history_db_service/history_db_service.dart';
import 'package:mysivi_chat/services/history_db_service/history_db_service_imp.dart';
import 'package:mysivi_chat/features/history/data/history_repository.dart';
import 'package:mysivi_chat/features/history/presentation/bloc/history_bloc.dart';
import 'package:mysivi_chat/services/api_service/api_service.dart';
import 'package:mysivi_chat/features/chat/data/chat_repository.dart';
import 'package:mysivi_chat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:mysivi_chat/features/users/domain/user_repository.dart';
import 'package:mysivi_chat/features/users/data/user_repository_imp.dart';
import 'package:mysivi_chat/features/users/presentation/bloc/user_bloc.dart';
import 'package:mysivi_chat/services/dictionary_service/dictionary_service.dart';
import 'package:mysivi_chat/services/dictionary_service/dictionary_service_imp.dart';

// Database
import '../database/app_database.dart';

// DB services

// External services

// Business services

final GetIt sl = GetIt.instance;

Future<void> setupInjection() async {
  // ---------------------------
  // Database (Singleton)
  // ---------------------------
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // ---------------------------
  // DB Services (Singleton)
  // ---------------------------
  sl.registerLazySingleton<UserDbService>(() => UserDbServiceImpl());

  sl.registerLazySingleton<MessageDbService>(() => MessageDbServiceImpl());

  // ---------------------------
  // External Services
  // ---------------------------
  sl.registerLazySingleton<ApiService>(() => ApiServiceImp());

  sl.registerLazySingleton<DictionaryService>(() => DictionaryServiceImp());

  // ---------------------------
  // Business Services
  // ---------------------------
  sl.registerLazySingleton<HistoryService>(
    () => HistoryServiceImpl(
      sl(), // MessageDbService
      sl(), // UserDbService
    ),
  );

  // ---------------------------
  // Repositories
  // ---------------------------
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepository(sl(), sl(), sl()),
  );

  sl.registerLazySingleton<HistoryRepository>(() => HistoryRepository(sl()));

  // ---------------------------
  // Blocs
  // ---------------------------
  sl.registerFactory<UserBloc>(() => UserBloc(sl(), sl()));

  sl.registerFactory<ChatBloc>(
    () => ChatBloc(chatRepository: sl(), messageDb: sl()),
  );

  sl.registerFactory<HistoryBloc>(() => HistoryBloc(sl(), sl()));
}
