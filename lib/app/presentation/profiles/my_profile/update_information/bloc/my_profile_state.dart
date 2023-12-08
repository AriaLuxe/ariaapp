part of 'my_profile_bloc.dart';

class MyProfileState extends Equatable {
  final NameInputValidator nameInputValidator;
  final LastNameInputValidator lastNameInputValidator;
  final BirthDateInputValidator birthDateInputValidator;
  final NicknameInputValidator nicknameInputValidator;
  final CountryInputValidator countryInputValidator;
  final CityInputValidator cityInputValidator;
  final GenderInputValidator genderInputValidator;
  final FormzSubmissionStatus formStatus;
  final bool isValid;

  const MyProfileState({
    this.genderInputValidator = const GenderInputValidator.pure(),
    this.countryInputValidator = const CountryInputValidator.pure(),
    this.nicknameInputValidator = const NicknameInputValidator.pure(),
    this.formStatus = FormzSubmissionStatus.initial,
    this.nameInputValidator = const NameInputValidator.pure(),
    this.lastNameInputValidator = const LastNameInputValidator.pure(),
    this.birthDateInputValidator = const BirthDateInputValidator.pure(),
    this.cityInputValidator = const CityInputValidator.pure(),
    this.isValid = false,
  });

  MyProfileState copyWith({
    GenderInputValidator? genderInputValidator,
    CountryInputValidator? countryInputValidator,
    NicknameInputValidator? nicknameInputValidator,
    FormzSubmissionStatus? formStatus,
    NameInputValidator? nameInputValidator,
    LastNameInputValidator? lastNameInputValidator,
    BirthDateInputValidator? birthDateInputValidator,
    CityInputValidator? cityInputValidator,
    bool? isValid,
  }) =>
      MyProfileState(
        genderInputValidator: genderInputValidator ?? this.genderInputValidator,
        countryInputValidator:
            countryInputValidator ?? this.countryInputValidator,
        nicknameInputValidator:
            nicknameInputValidator ?? this.nicknameInputValidator,
        formStatus: formStatus ?? this.formStatus,
        nameInputValidator: nameInputValidator ?? this.nameInputValidator,
        lastNameInputValidator:
            lastNameInputValidator ?? this.lastNameInputValidator,
        birthDateInputValidator:
            birthDateInputValidator ?? this.birthDateInputValidator,
        isValid: isValid ?? this.isValid,
        cityInputValidator: cityInputValidator ?? this.cityInputValidator,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        formStatus,
        nameInputValidator,
        lastNameInputValidator,
        birthDateInputValidator,
        nicknameInputValidator,
        countryInputValidator,
        cityInputValidator,
        genderInputValidator,
      ];
}
