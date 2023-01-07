
// ignore_for_file: camel_case_types

class convert{

  static double currencyToDouble(String value){
    return double.parse(
      value.replaceAll('R\$ ','')
      .replaceAll('.','')
      .replaceAll(',','.'));
  }

  //receive 01/10/2001 and return 20011001
  // ignore: non_constant_identifier_names
  static String DateBrToDatabase(String date){
    var d = date.split('/');
    return d[2] + d[1] + d[0];
  }

  //receive 01/10/2001 and return 2001/10/01
  // ignore: non_constant_identifier_names
  static String DateBrToDateUsa(String date){
    var d = date.split('/');
    return d[2] + '/' + d[1] +'/' + d[0];
  }

  // ignore: non_constant_identifier_names
  static String DatetimeToDateBr(DateTime d){
    String helpDay = '';
    if(d.day<10){
      helpDay = '0';
    }

    String helpMonth = '';
    if(d.month<10){
      helpMonth = '0';
    }
    return (helpDay + d.day.toString() + '/' + helpMonth + d.month.toString() + '/' + d.year.toString());
  }

  // convert String(01/01/2001) to Datetime
  // ignore: non_constant_identifier_names
  static DateTime StringToDatetime(String date){
    var d = date.split('/');
    return DateTime.parse(d[2] + '-' + d[1] +'-' + d[0]);
  }

  // ignore: non_constant_identifier_names
  static String DatetimeMonthBr(int m){
    switch(m){
      case 1:
        return "JANEIRO";
      case 2:
        return "FEVEREIRO";
      case 3:
        return "MARÇO";
      case 4:
        return "ABRIL";
      case 5:
        return "MAIO";
      case 6:
        return "JUNHO";
      case 7:
        return "JULHO";
      case 8:
        return "AGOSTO";
      case 9:
        return "SETEMBRO"; 
      case 10:
        return "OUTUBRO";
      case 11:
        return "NOVEMBRO"; 
      case 12:
        return "DEZEMBRO";
    }
    return "";
  }

}