import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/todo.dart';
import '../repository/todo_repository.dart';


class DeleteTodoUsecase extends UseCase<void, Todo> {
  final TodoRepository repository;

  DeleteTodoUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(Todo todo) async {
    return await repository.deleteTodo(todo);
  }
}
