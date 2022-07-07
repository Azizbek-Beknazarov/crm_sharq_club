import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entity/todo.dart';


abstract class TodoRepository {
  Future<Either<Failure, void>> addNewTodo(Todo todo);
  Future<Either<Failure, void>> deleteTodo(Todo todo);
  Future<Either<Failure, void>> updateTodo(Todo todo);

  Future<Either<Failure, Stream<List<Todo>>>> todos();
}
