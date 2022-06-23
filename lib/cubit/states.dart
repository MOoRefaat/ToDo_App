import 'cubit.dart';

abstract class AppStates {}

class IntialAppState extends AppStates {}

class AppChangeButtomNavBar extends AppStates {}

class CreateDatabaseState extends AppStates {}

class InsertToDatabaseState extends AppStates {}

class GetDataFromDatabaseState extends AppStates {}

class UpdateDatabaseState extends AppStates {}

class DeleteDatabaseState extends AppStates {}

class GetDataFromDatabaseLoadingState extends AppStates {}

class ChangeBottomSheetShowState extends AppStates {}
