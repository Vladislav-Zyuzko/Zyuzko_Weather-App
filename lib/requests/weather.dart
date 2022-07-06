import 'package:dio/dio.dart';

class Weather {
  int _cityId = 0;
  String _cityName = "";

  final _appid = '69856b5b43fc307c7b50ccafb0b06dbf';
  final _units = 'metric';

  BaseOptions options = BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: 30*1000,
    receiveTimeout: 30*1000,
  );

  String _windDirection(int deg) {
    if(deg >= 22.5 && deg < 67.5) {return "СВ";}
    else if(deg >= 67.5 && deg < 112.5) {return "В";}
    else if(deg >= 112.5 && deg < 157.5) {return "ЮВ";}
    else if(deg >= 157.5 && deg < 202.5) {return "Ю";}
    else if(deg >= 202.5 && deg < 247.5) {return "ЮЗ";}
    else if(deg >= 247.5 && deg < 292.5) {return "З";}
    else if(deg >= 292.5 && deg < 337.5) {return "СЗ";}
    else {return "C";}
  }

  Map<String, String> _queryParameters(Map<String, String> newParameter) {
    final parameters = <String, String>{
      'type': 'like',
      'id': _cityId.toString(),
      'units': _units,
      'lang': 'ru',
      'APPID': _appid,
    };
    parameters.addAll(newParameter);
    return parameters;
  }

  Future<int> findCity(String city) async {
    _cityName = city;
    Dio dio = Dio(options);
    try {
      Response response = await dio.request(
        'http://api.openweathermap.org/data/2.5/find',
        options: Options(method: 'GET'),
        queryParameters: <String, String>{
          'q': city,
          'units': _units,
          'APPID': _appid,
        },
      );
      _cityId = response.data['count'] == 0 ? 0 : response.data['list'][0]['id'];
      print(_cityId);
      return _cityId;
    } on DioError  {return -1;}
  }

  Future<Map<String, dynamic>> getNowWeather() async {

    final weatherMap = <String, dynamic>{};
    Dio dio = Dio(options);

    try {
      Response response = await dio.request(
        'http://api.openweathermap.org/data/2.5/weather',
        options: Options(method: 'GET'),
        queryParameters: _cityId > 0 ? _queryParameters(<String, String>{"id": _cityId.toString()}) : _queryParameters(<String, String>{"q": _cityName}),
      );
      weatherMap['Описание'] = response.data['weather'][0]['description'];
      weatherMap['Температура'] = response.data['main']['temp'].round();
      weatherMap['Давление'] = response.data['main']['pressure'];
      weatherMap['Влажность'] = response.data['main']['humidity'];
      weatherMap['Скорость ветра'] = response.data['wind']['speed'];
      weatherMap['Направление ветра'] = _windDirection(response.data['wind']['deg']);
      print(weatherMap);
      return weatherMap;
    } on DioError  {return weatherMap;}
  }

  Future<List<dynamic>> getLongForecast() async {

    final forecastList = [];
    Dio dio = Dio(options);

    try {
      Response response = await dio.request(
        'http://api.openweathermap.org/data/2.5/forecast',
        options: Options(method: 'GET'),
        queryParameters: _cityId > 0 ? _queryParameters(<String, String>{"id": _cityId.toString()}) : _queryParameters(<String, String>{"q": _cityName}),
    );
      for (var i in response.data['list']) {
        Map weatherMap = <String, dynamic>{};
        weatherMap['Дата'] = i['dt_txt'].split(" ")[0];
        weatherMap['Время'] = i['dt_txt'].split(" ")[1].substring(0, 5);
        weatherMap['Описание'] = i['weather'][0]['description'];
        weatherMap['Температура'] = i['main']['temp'].round();
        weatherMap['Скорость ветра'] = i['wind']['speed'];
        weatherMap['Направление ветра'] = _windDirection(i['wind']['deg']);
        forecastList.add(weatherMap);
      }
      print(forecastList);
      return forecastList;
    } on DioError  {return forecastList;}
  }
}
