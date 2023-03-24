
class ClientRegister {
  int? id;
  String? name;
  String? type;

  ClientRegister(this.id, this.name,this.type);

  static ClientRegister getDefault() {
    return ClientRegister(1,"Teste","J");
  }

}