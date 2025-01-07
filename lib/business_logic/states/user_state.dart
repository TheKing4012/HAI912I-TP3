class UserState {}

class UserLoadingState extends UserState {}

class UserLoadedState extends UserState {
  final List<Map<String, dynamic>> users;

  UserLoadedState(this.users);
}

class UserErrorState extends UserState {
  final String error;

  UserErrorState(this.error);
}