import 'package:drift_model_generator/src/utils/make_snake.dart';

extension EnumSnakeName on Enum {
  String get snakeName => makeSnake(name);
}
