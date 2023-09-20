part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  final NameInputValidator nameInputValidator;
  final LastNameInputValidator lastNameInputValidator;
  final PasswordInputValidator passwordInputValidator;
  final BirthDateInputValidator birthDateInputValidator;
  final EmailInputValidator emailInputValidator;
  final NicknameInputValidator nicknameInputValidator;
  final CountryInputValidator countryInputValidator;
  final CityInputValidator cityInputValidator;
  final GenderInputValidator genderInputValidator;
  final FormzSubmissionStatus formStatus;
  final bool isValid;

  const SignUpState({
    this.genderInputValidator = const GenderInputValidator.pure(),
    this.countryInputValidator = const CountryInputValidator.pure(),
    this.nicknameInputValidator = const NicknameInputValidator.pure(),
    this.formStatus = FormzSubmissionStatus.initial,
    this.nameInputValidator = const NameInputValidator.pure(),
    this.lastNameInputValidator = const LastNameInputValidator.pure(),
    this.emailInputValidator = const EmailInputValidator.pure(),
    this.passwordInputValidator = const PasswordInputValidator.pure(),
    this.birthDateInputValidator = const BirthDateInputValidator.pure(),
    this.cityInputValidator = const CityInputValidator.pure(),
    this.isValid = false,
  });

  SignUpState copyWith({
    GenderInputValidator? genderInputValidator,
    CountryInputValidator? countryInputValidator,
    NicknameInputValidator? nicknameInputValidator,
    FormzSubmissionStatus? formStatus,
    NameInputValidator? nameInputValidator,
    LastNameInputValidator? lastNameInputValidator,
    EmailInputValidator? emailInputValidator,
    PasswordInputValidator? passwordInputValidator,
    BirthDateInputValidator? birthDateInputValidator,
    CityInputValidator? cityInputValidator,
    bool? isValid,
  }) =>
      SignUpState(
        genderInputValidator: genderInputValidator ?? this.genderInputValidator,
        countryInputValidator:
            countryInputValidator ?? this.countryInputValidator,
        nicknameInputValidator:
            nicknameInputValidator ?? this.nicknameInputValidator,
        formStatus: formStatus ?? this.formStatus,
        nameInputValidator: nameInputValidator ?? this.nameInputValidator,
        lastNameInputValidator:
            lastNameInputValidator ?? this.lastNameInputValidator,
        emailInputValidator: emailInputValidator ?? this.emailInputValidator,
        passwordInputValidator:
            passwordInputValidator ?? this.passwordInputValidator,
        birthDateInputValidator:
            birthDateInputValidator ?? this.birthDateInputValidator,
        isValid: isValid ?? this.isValid,
        cityInputValidator: cityInputValidator ?? this.cityInputValidator,
      );

  @override
  List<Object?> get props => [
        formStatus,
        nameInputValidator,
        lastNameInputValidator,
        emailInputValidator,
        passwordInputValidator,
        birthDateInputValidator,
        nicknameInputValidator,
        countryInputValidator,
        cityInputValidator,
        genderInputValidator,
      ];
}
