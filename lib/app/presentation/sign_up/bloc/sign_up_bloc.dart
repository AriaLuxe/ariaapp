import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';

import '../validators/birthdate_input_validator.dart';
import '../validators/city_input_validator.dart';
import '../validators/country_input_validator.dart';
import '../validators/email_input_validator.dart';
import '../validators/gender_input_validator.dart';
import '../validators/last_name_input_validator.dart';
import '../validators/name_input_validator.dart';
import '../validators/nickname_input_validator.dart';
import '../validators/password_input_validator.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserAriaRepository usersRepository;

  SignUpBloc()
      : usersRepository = GetIt.instance<UserAriaRepository>(),
        super(const SignUpState()) {
    on<SignUpEvent>((event, emit) {});
    on<NameChanged>(_onNameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LastNameChanged>(_onLastNameChanged);
    on<BirthDateChanged>(_onBirthDateChanged);
    on<NicknameChanged>(_onNicknameChanged);
    on<CountryChanged>(_onCountryChanged);
    on<CityChanged>(_onCityChanged);
    on<GenderChanged>(_onGenderChanged);
  }

  void _onGenderChanged(GenderChanged event, Emitter<SignUpState> emit) {
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
            state.emailInputValidator,
            state.passwordInputValidator,
            state.lastNameInputValidator,
            state.birthDateInputValidator,
          ],
        ),
      ),
    );
  }

  void _onCityChanged(CityChanged event, Emitter<SignUpState> emit) {
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
            state.emailInputValidator,
            state.passwordInputValidator,
            state.lastNameInputValidator,
            state.birthDateInputValidator,
            state.genderInputValidator,
          ],
        ),
      ),
    );
  }

  void _onCountryChanged(CountryChanged event, Emitter<SignUpState> emit) {
    final country = CountryInputValidator.dirty(event.country);
    emit(
      state.copyWith(
        countryInputValidator: country,
        isValid: Formz.validate(
          [
            country,
            state.nicknameInputValidator,
            state.nameInputValidator,
            state.emailInputValidator,
            state.passwordInputValidator,
            state.lastNameInputValidator,
            state.birthDateInputValidator,
            state.genderInputValidator,
            state.cityInputValidator,
          ],
        ),
      ),
    );
  }

  void _onNicknameChanged(
      NicknameChanged event, Emitter<SignUpState> emit) async {
    final bool isNicknameAvailable =
        await usersRepository.validateNickname(event.nickname);

    final nickname = NicknameInputValidator.dirty(
        isNicknameAvailable ? 'true' : event.nickname);

    emit(
      state.copyWith(
        nicknameInputValidator: nickname,
        isValid: Formz.validate(
          [
            nickname,
            state.nameInputValidator,
            state.emailInputValidator,
            state.passwordInputValidator,
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

  void _onNameChanged(NameChanged event, Emitter<SignUpState> emit) {
    final name = NameInputValidator.dirty(event.name);
    emit(
      state.copyWith(
        nameInputValidator: name,
        isValid: Formz.validate(
          [
            name,
            state.emailInputValidator,
            state.passwordInputValidator,
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

  void _onLastNameChanged(LastNameChanged event, Emitter<SignUpState> emit) {
    final lastName = LastNameInputValidator.dirty(event.lastName);
    emit(
      state.copyWith(
        lastNameInputValidator: lastName,
        isValid: Formz.validate(
          [
            state.nameInputValidator,
            state.emailInputValidator,
            state.passwordInputValidator,
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

  void _onBirthDateChanged(BirthDateChanged event, Emitter<SignUpState> emit) {
    final birthDate = BirthDateInputValidator.dirty(event.birthDate);
    emit(
      state.copyWith(
        birthDateInputValidator: birthDate,
        isValid: Formz.validate(
          [
            state.nicknameInputValidator,
            state.countryInputValidator,
            state.nameInputValidator,
            state.emailInputValidator,
            state.passwordInputValidator,
            state.lastNameInputValidator,
            birthDate,
            state.cityInputValidator,
            state.countryInputValidator,
          ],
        ),
      ),
    );
  }

  void _onEmailChanged(EmailChanged event, Emitter<SignUpState> emit) {
    final email = EmailInputValidator.dirty(event.email);
    emit(
      state.copyWith(
        emailInputValidator: email,
        isValid: Formz.validate(
          [
            state.nameInputValidator,
            email,
            state.passwordInputValidator,
            state.lastNameInputValidator,
            state.birthDateInputValidator,
            state.cityInputValidator,
            state.countryInputValidator,
            state.nicknameInputValidator,
            state.genderInputValidator,
          ],
        ),
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<SignUpState> emit) {
    final password = PasswordInputValidator.dirty(event.password);
    emit(
      state.copyWith(
        passwordInputValidator: password,
        isValid: Formz.validate(
          [
            state.nameInputValidator,
            state.lastNameInputValidator,
            state.nicknameInputValidator,
            state.emailInputValidator,
            password,
            state.birthDateInputValidator,
            state.cityInputValidator,
            state.countryInputValidator,
            state.genderInputValidator,
          ],
        ),
      ),
    );
  }
}
