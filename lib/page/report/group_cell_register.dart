
class GroupCellRegister{
  double sum = 0;

  add(double value,bool credit){
    if(credit){
      sum += value;
    }else{
      sum -= value;
    }
  }

}