import 'package:shared_preferences/shared_preferences.dart';

abstract class CarLocalDataSource {}

const CACHED_TODOS = 'CACHED_TODOS';

class CarLocalDataSourceImpl implements CarLocalDataSource {
  final SharedPreferences sharedPreferences;

  CarLocalDataSourceImpl({required this.sharedPreferences});
}
