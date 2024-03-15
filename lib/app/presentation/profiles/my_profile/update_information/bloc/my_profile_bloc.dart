import 'package:ariapp/app/presentation/sign_up/validators/name_input_validator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/repositories/user_aria_repository.dart';
import '../../../../../security/shared_preferences_manager.dart';
import '../validators/birthdate_input_validator.dart';
import '../validators/city_input_validator.dart';
import '../validators/country_input_validator.dart';
import '../validators/gender_input_validator.dart';
import '../validators/last_name_input_validator.dart';
import '../validators/nickname_input_validator.dart';

part 'my_profile_event.dart';

part 'my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  final UserAriaRepository userAriaRepository;

  MyProfileBloc()
      : userAriaRepository = GetIt.instance<UserAriaRepository>(),
        super(const MyProfileState()) {
    on<MyProfileEvent>((event, emit) {});
    on<NameChanged>(_onNameChanged);
    on<LastNameChanged>(_onLastNameChanged);
    on<BirthDateChanged>(_onBirthDateChanged);
    on<NicknameChanged>(_onNicknameChanged);
    on<CountryChanged>(_onCountryChanged);
    on<CityChanged>(_onCityChanged);
    on<GenderChanged>(_onGenderChanged);
    on<CurrentProfile>(_onCurrentProfile);
  }

  void _onGenderChanged(GenderChanged event, Emitter<MyProfileState> emit) {
    final gender = GenderInputValidator.dirty(event.gender);
    emit(
      state.copyWith(
        genderInputValidator: gender,
        isValid: Formz.validate(
          [
            gender,
            state.cityInputValidator,
            state.countryInputValidator,
            state.nicknameInputValidator,
            state.nameInputValidator,
            state.lastNameInputValidator,
            state.birthDateInputValidator,
          ],
        ),
      ),
    );
  }

  void _onCityChanged(CityChanged event, Emitter<MyProfileState> emit) {
    final city = CityInputValidator.dirty(event.city);
    emit(
      state.copyWith(
        cityInputValidator: city,
        isValid: Formz.validate(
          [
            city,
            state.countryInputValidator,
            state.nicknameInputValidator,
            state.nameInputValidator,
            state.lastNameInputValidator,
            state.birthDateInputValidator,
            state.genderInputValidator,
          ],
        ),
      ),
    );
  }

  void _onCountryChanged(CountryChanged event, Emitter<MyProfileState> emit) {
    final country = CountryInputValidator.dirty(event.country);
    emit(
      state.copyWith(
        countryInputValidator: country,
        isValid: Formz.validate(
          [
            country,
            state.nicknameInputValidator,
            state.nameInputValidator,
            state.lastNameInputValidator,
            state.birthDateInputValidator,
            state.genderInputValidator,
            state.cityInputValidator,
          ],
        ),
      ),
    );
  }

  void _onNicknameChanged(NicknameChanged event, Emitter<MyProfileState> emit) {
    final nickname = NicknameInputValidator.dirty(event.nickname);
    emit(
      state.copyWith(
        nicknameInputValidator: nickname,
        isValid: Formz.validate(
          [
            nickname,
            state.nameInputValidator,
            state.lastNameInputValidator,
            state.birthDateInputValidator,
            state.cityInputValidator,
            state.genderInputValidator,
            state.countryInputValidator,
          ],
        ),
      ),
    );
  }

  void _onNameChanged(NameChanged event, Emitter<MyProfileState> emit) {
    final name = NameInputValidator.dirty(event.name);
    emit(
      state.copyWith(
        nameInputValidator: name,
        isValid: Formz.validate(
          [
            name,
            state.lastNameInputValidator,
            state.birthDateInputValidator,
            state.cityInputValidator,
            state.genderInputValidator,
            state.countryInputValidator,
            state.nicknameInputValidator,
          ],
        ),
      ),
    );
  }

  void _onLastNameChanged(LastNameChanged event, Emitter<MyProfileState> emit) {
    final lastName = LastNameInputValidator.dirty(event.lastName);
    emit(
      state.copyWith(
        lastNameInputValidator: lastName,
        isValid: Formz.validate(
          [
            state.nameInputValidator,
            lastName,
            state.birthDateInputValidator,
            state.cityInputValidator,
            state.genderInputValidator,
            state.countryInputValidator,
            state.nicknameInputValidator,
          ],
        ),
      ),
    );
  }

  void _onBirthDateChanged(
      BirthDateChanged event, Emitter<MyProfileState> emit) {
    final birthDate = BirthDateInputValidator.dirty(event.birthDate);
    emit(
      state.copyWith(
        birthDateInputValidator: birthDate,
        isValid: Formz.validate(
          [
            state.nicknameInputValidator,
            state.countryInputValidator,
            state.nameInputValidator,
            state.lastNameInputValidator,
            birthDate,
            state.cityInputValidator,
            state.countryInputValidator,
          ],
        ),
      ),
    );
  }

  void _onCurrentProfile(
    CurrentProfile event,
    Emitter<MyProfileState> emit,
  ) async {
    final userUd = await SharedPreferencesManager.getUserId();
    final user = await userAriaRepository.getUserById(userUd!);
    emit(state.copyWith(
      nameInputValidator: NameInputValidator.dirty(user.nameUser),
      lastNameInputValidator: LastNameInputValidator.dirty(user.lastName),
      nicknameInputValidator: NicknameInputValidator.dirty(user.nickname),
      genderInputValidator: GenderInputValidator.dirty(user.gender),
      birthDateInputValidator: BirthDateInputValidator.dirty(user.gender),
      countryInputValidator: CountryInputValidator.dirty(user.gender),
      cityInputValidator: CityInputValidator.dirty(user.gender),
    ));
  }

  void currentProfile() {
    add(const CurrentProfile());
  }
}
