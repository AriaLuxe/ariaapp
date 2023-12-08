class Follower {
  final int? idRequest;
  final int idUser;
  final String nameUser;
  final String lastName;
  final String nickName;
  final String? imgProfile;
  bool follow;

  Follower({
    this.idRequest,
    required this.idUser,
    required this.nameUser,
    required this.lastName,
    required this.nickName,
    this.imgProfile,
    required this.follow,
  });
}
