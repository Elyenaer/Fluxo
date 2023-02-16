// ignore_for_file: file_names
// ignore: camel_case_types
class funcNumber{

  //ex.: number: 1 / digits: 3 = 001
  static String includeZero(int number,int digits){

    var result = '';
    for(var i=0;i<(digits-number.toString().length);i++){
      result = result + '0';
    }
    result = result + number.toString();

    return result;
  }

}