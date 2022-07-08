import 'package:flutter/material.dart';
import 'package:weather_app/requests/weather.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter_charts/flutter_charts.dart';

class MainContent extends StatefulWidget {
  const MainContent(
      {super.key,
      required this.weather,
      required this.weatherLog,
      required this.iconsMap,
      required this.forecastLog,
      required this.iconUrl});

  final Weather weather;
  final Map<String, String> iconsMap;
  final String iconUrl;
  final Map<String, dynamic> weatherLog;
  final List<dynamic> forecastLog;

  @override
  State<MainContent> createState() => _MainContent();
}

class _MainContent extends State<MainContent> {
  List<double> getTempList() {
    List<double> tempList = [];
    for (var forecastMap in widget.forecastLog) {
      tempList.add(forecastMap['Температура'].toDouble());
    }
    return tempList;
  }

  List<String> getTimeList() {
    List<String> timeList = [];
    for (var forecastMap in widget.forecastLog) {
      timeList.add(forecastMap['Время']);
    }
    return timeList;
  }

  List<dynamic> getMeanTempList() {
    List<String> dataList = [];
    List<double> meanTempList = [];
    String nowDay = widget.forecastLog[0]['День'];
    int indexNextDay = 0;
    for (int i = 0; i < widget.forecastLog.length; i++) {
      if (widget.forecastLog[i]['День'] != nowDay) {
        indexNextDay = i;
        break;
      }
    }
    List<double> tempList = getTempList().sublist(indexNextDay);
    for (int i = 0; i <= 24; i += 8) {
      meanTempList.add(tempList.sublist(i, i + 8).reduce((a, b) => a + b) / 8);
      dataList.add(
          widget.forecastLog[i]['День'] + " " + widget.forecastLog[i]['Месяц']);
    }
    return [meanTempList, dataList];
  }

  Widget linearChart() {
    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = ChartOptions(
      lineChartOptions: LineChartOptions(
        hotspotInnerPaintColor: Colors.yellow.shade200,
      ),
      labelCommonOptions: const LabelCommonOptions(
        labelTextScaleFactor: 1.4,
      ),
      dataContainerOptions: const DataContainerOptions(
        startYAxisAtDataMinRequested: true,
      ),
    );

    chartData = ChartData(
      dataRows: [
        getTempList(),
      ],
      dataRowsColors: const [
        Colors.blueGrey,
      ],
      xUserLabels: getTimeList(),
      dataRowsLegends: const [
        'Температура °C',
      ],
      chartOptions: chartOptions,
    );
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var lineChart = LineChart(
      painter: LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );
    return lineChart;
  }

  Widget verticalBarChart() {

    List<dynamic> meanTempList = getMeanTempList();

    LabelLayoutStrategy xContainerLabelLayoutStrategy ;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions(
      labelCommonOptions: LabelCommonOptions(
        labelTextScaleFactor: 1.2,
      ),
      iterativeLayoutOptions: IterativeLayoutOptions(
        decreaseLabelFontRatio: 45.0,
      ),
    );
    xContainerLabelLayoutStrategy = DefaultIterativeLabelLayoutStrategy(
        options: chartOptions,
    );
    chartData = ChartData(
      dataRows: [
        meanTempList[0],
      ],
      dataRowsColors: [
        Colors.yellow.shade200,
      ],
      xUserLabels: meanTempList[1],
      dataRowsLegends: const [
        'Температура °С',
      ],
      chartOptions: chartOptions,
    );
    var verticalBarChartContainer = VerticalBarChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var verticalBarChart = VerticalBarChart(
      painter: VerticalBarChartPainter(
        verticalBarChartContainer: verticalBarChartContainer,
      ),
    );
    return verticalBarChart;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 50.0)),
          Text(
            'Погода ${widget.weather.getCityName()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 50.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: Image.asset(
                  widget.iconUrl,
                  scale: 1.2,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 30)),
              Text(
                '${widget.weatherLog['Температура'] ?? 0.toString()}°',
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.white70,
                  Colors.blueGrey,
                ])),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    const Icon(Icons.water_drop,
                        color: Colors.blueGrey, size: 40.0),
                    const Padding(padding: EdgeInsets.only(top: 10.0)),
                    Text(
                      '${widget.weatherLog['Влажность'] ?? 0}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const Icon(WeatherIcons.barometer,
                        color: Colors.blueGrey, size: 40.0),
                    const Padding(padding: EdgeInsets.only(top: 18.0)),
                    Text(
                      '${widget.weatherLog['Давление'] ?? 0}мм.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const Icon(WeatherIcons.wind_beaufort_1,
                        color: Colors.blueGrey, size: 40.0),
                    const Padding(padding: EdgeInsets.only(top: 18.0)),
                    Text(
                      '${widget.weatherLog['Скорость ветра'].round() ?? 0}м/с',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    WindIcon(
                      degree: widget.weatherLog['Угол ветра'] ?? 90,
                      color: Colors.blueGrey,
                      size: 40.0,
                    ),
                    Text(
                      '${widget.weatherLog['Направление ветра'] ?? "С"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            color: Colors.black45,
            height: 220,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.forecastLog.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 10.0),
                    child: Column(
                      children: [
                        Text(
                          "${widget.forecastLog[index]['День']} ${widget.forecastLog[index]['Месяц']}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.forecastLog[index]['Время']}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Image.asset(
                          widget.iconsMap[widget.forecastLog[index]
                                  ['Иконка']] ??
                              "assets/gifs/loader.gif",
                          scale: 1.5,
                        ),
                        Text(
                          "${widget.forecastLog[index]['Температура']}°",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
          const Padding(padding: EdgeInsets.only(top: 50)),
          Container(
              child: widget.forecastLog.isNotEmpty
                  ? Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: verticalBarChart(),
                  )
                  : const SizedBox(height: 0, width: 0)
          ),
          const Padding(padding: EdgeInsets.only(top: 50)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: widget.forecastLog.isNotEmpty
                ? Container(
                    height: 250,
                    width: 700,
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(50.0)),
                    ),
                    child: linearChart(),
                  )
                : const SizedBox(height: 0, width: 0),
          ),
        ],
      ),
    );
  }
}
