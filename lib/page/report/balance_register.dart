
class BalanceRegister{
  String description;
  List<double> sum = [];

  BalanceRegister(this.description,int periodsLenght){
    for(int i=0;i<periodsLenght;i++){
      sum.add(0);
    }
  }

  add(int index,double value){
    sum[index] += value;
  }

}