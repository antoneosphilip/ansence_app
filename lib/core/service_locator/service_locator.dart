



import 'package:get_it/get_it.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_cubit.dart';
import 'package:summer_school_app/view_model/repo/absence_repo/absence.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  sl.registerLazySingleton<AbsenceRepo>(() => AbsenceRepo());


  // sl.registerLazySingleton<AddFavoriteRepoImpl>(() => AddFavoriteRepoImpl());


  // cubit
}
