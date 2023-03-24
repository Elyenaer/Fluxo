class UserRegister {
  int? id;
  String? name;
  String? email; 

  UserRegister(this.id,this.name,this.email);

  static UserRegister getDefault(){
    return UserRegister(1,'test','test@test.com');
  }
}