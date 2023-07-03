import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:using_firebase/model/user_model.dart';
import 'package:using_firebase/repository/database_repository_impl.dart';



part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final DatabaseRepository _databaseRepository;
  DatabaseBloc(this._databaseRepository) : super(DatabaseInitial()) {
    on<DatabaseFetched>(_fetchUserData);
  }

  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
    List<UserModel> listOfUserData = await _databaseRepository.retrieveUserData();
    emit(DatabaseSuccess(listOfUserData,event.displayName));
  }
}