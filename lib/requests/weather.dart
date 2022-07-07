import 'package:dio/dio.dart';

class Weather {

  int _cityId = 0;
  int _timezone = 21600;

  String _cityName = "Омск";

  bool _status = true;

  final _appid = '69856b5b43fc307c7b50ccafb0b06dbf';
  final _units = 'metric';

  final Map <int, String> _monthsMap = <int, String> {
    1: 'Января',
    2: 'Февраля',
    3: 'Марта',
    4: 'Апреля',
    5: 'Мая',
    6: 'Июня',
    7: 'Июля',
    8: 'Августа',
    9: 'Сентября',
    10: 'Октября',
    11: 'Ноября',
    12: 'Декабря',
  };

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

  String _getLocalTime (int dt) {
    return "${DateTime.fromMillisecondsSinceEpoch((dt + _timezone) * 1000).hour}:00";
  }

  String _getLocalDay (int dt) {
    return "${DateTime.fromMillisecondsSinceEpoch((dt + _timezone) * 1000).day}";
  }

  int _getLocalMonth (int dt) {
    return DateTime.fromMillisecondsSinceEpoch((dt + _timezone) * 1000).month;
  }

  Map<String, String> _queryParameters(Map<String, String> newParameter) {
    final parameters = <String, String>{
      'id': _cityId.toString(),
      'units': _units,
      'lang': 'ru',
      'APPID': _appid,
    };
    parameters.addAll(newParameter);
    return parameters;
  }

  bool getStatus() {
    return _status;
  }

  String getCityName() {
    return _cityName;
  }

  void setCityName(String cityName) {
    _cityName = cityName;
  }

  Future<int> findCity(String city) async {
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
      return _cityId;
    } on DioError  { return -1;}
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
      weatherMap['Иконка'] = response.data['weather'][0]['icon'];
      weatherMap['Температура'] = response.data['main']['temp'].round();
      weatherMap['Давление'] = response.data['main']['pressure'];
      weatherMap['Влажность'] = response.data['main']['humidity'];
      weatherMap['Скорость ветра'] = response.data['wind']['speed'];
      weatherMap['Направление ветра'] = _windDirection(response.data['wind']['deg']);
      weatherMap['Угол ветра'] = response.data['wind']['deg'];
      _status = true;
      return weatherMap;
    } on DioError  {_status = false; return weatherMap;}
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
      _timezone = response.data['city']['timezone'];
      for (var i in response.data['list']) {
        Map weatherMap = <String, dynamic>{};
        weatherMap['День'] = _getLocalDay(i['dt']);
        weatherMap['Месяц'] = _monthsMap[_getLocalMonth(i['dt'])];
        weatherMap['Время'] = _getLocalTime(i['dt']);
        weatherMap['Описание'] = i['weather'][0]['description'];
        weatherMap['Иконка'] = i['weather'][0]['icon'];
        weatherMap['Температура'] = i['main']['temp'].round();
        weatherMap['Скорость ветра'] = i['wind']['speed'];
        weatherMap['Направление ветра'] = _windDirection(i['wind']['deg']);
        forecastList.add(weatherMap);
      }
      _status = true;
      return forecastList;
    } on DioError  {_status = false; return forecastList;}
  }
}
