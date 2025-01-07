import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/user_repository.dart';
import '../events/user_event.dart';
import '../states/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserLoadingState());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserLoadEvent) {
      yield UserLoadingState();
      try {
        final users = await userRepository.getUsers();
        yield UserLoadedState(users);
      } catch (e) {
        yield UserErrorState(e.toString());
      }
    }
  }
}
