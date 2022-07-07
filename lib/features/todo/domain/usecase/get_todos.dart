import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entity/todo.dart';
import '../repository/todo_repository.dart';


class GetTodosUsecase {
  final TodoRepository repository;

  GetTodosUsecase(this.repository);

  Future<Either<Failure, Stream<List<Todo>>>> call() {
    return repository.todos();
  }
}
