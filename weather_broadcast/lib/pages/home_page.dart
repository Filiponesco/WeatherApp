import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_broadcast/models/forecast_entity.dart';
import 'package:weather_broadcast/additional_functions.dart';
import 'package:weather_broadcast/widgets/forecast_lookup.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../repository.dart';
import 'forecast_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
//    HomePageState()._getCurrentLocation();
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final repo = Repository.getInstance();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Future<List<Future<ForecastEntity>>> _forecasts;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _forecasts = repo.allSavedCities().then((result) {
      return List.generate(result.length, (i) {
        return repo.getBroadcastForCity(result[i]);
      });
    });

    Widget _futureLookup(Future<ForecastEntity> forecast,
        {bool favorite = false, bool dismissible = false}) {
      return FutureBuilder(
        future: forecast,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              (snapshot.data as ForecastEntity).favorite = favorite;
              return dismissible
                  ? Dismissible(
                      child: ForecastLookup(forecast: snapshot.data),
                      key: Key((snapshot.data as ForecastEntity).name),
                      onDismissed: (direction) {
                        setState(() {
                          repo.deleteCity(
                              (snapshot.data as ForecastEntity).name);
                        });
                      },
                    )
                  : ForecastLookup(forecast: snapshot.data);
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Problem with connection to API"),
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
          enablePullUp: false,
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: () {
            setState(() {});
            _refreshController.refreshCompleted();
          },
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Current location",
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _futureLookup(repo.getBroadcastForGPS()),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Saved locations",
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              FutureBuilder(
                future: _forecasts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      var _lookups = List<Widget>();
                      for (var forecast in snapshot.data) {
                        _lookups.add(_futureLookup(
                          forecast,
                          favorite: true,
                          dismissible: true,
                        ));
                      }
                      return Column(
                        children: _lookups,
                      );
                    } else if (snapshot.hasError) {
                      toast("Problem with connection to database");
                      return Column();
                    }
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          _searchDialog(context, repo);
        },
      ),
    );
  }
}

void _searchDialog(BuildContext context, Repository repo) {
  bool _loading = false;
  bool _isError = false;
  String _messageError;
  TextEditingController cityToSearch = TextEditingController();
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text('Search city'),
          content: TextField(
              controller: cityToSearch,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'City',
                errorText: _isError ? _messageError : null,
                suffixIcon: IconButton(
                  onPressed: () => cityToSearch.clear(),
                  icon: Icon(Icons.clear),
                ),
              ),
              textInputAction: TextInputAction.search,
              textCapitalization: TextCapitalization.words,
              onSubmitted: (s) {
                if(cityToSearch.text.isEmpty) {
                  setState(() {
                    _isError = true;
                    _messageError = "The field cannot be empty";
                  });
                }
                else {
                  setState(() {
                    if (!_loading) _loading = true;
                  });
                  Future<ForecastEntity> forecastFoundFuture =
                  repo.getBroadcastForCity(cityToSearch.text);
                  forecastFoundFuture.then((data) {
                    _loading = false;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ForecastPage(forecast: data))).then((result) {
                      Navigator.of(context).pop(); //remove dialog
                    });
                  }).catchError((error) {
                    debugPrint("Error");
                    setState(() {
                      _loading = false;
                      _isError = true;
                      _messageError = error;
                    });
                  });
                } //Else
              }),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
                color: Colors.blue,
                child: btnWithLoading(_loading),
                onPressed: () {
                  if(cityToSearch.text.isEmpty) {
                    setState(() {
                      _isError = true;
                      _messageError = "The field cannot be empty";
                    });
                  }
                  else {
                    setState(() {
                      if (!_loading) _loading = true;
                    }); // setState
                    Future<ForecastEntity> forecastFoundFuture =
                    repo.getBroadcastForCity(cityToSearch.text);
                    forecastFoundFuture.then((data) {
                      _loading = false;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ForecastPage(forecast: data))).then((result) {
                        Navigator.of(context).pop(); //Remove dialog
                      });
                    }).catchError((error) {
                      debugPrint("Error");
                      setState(() {
                        _loading = false;
                        _isError = true;
                        _messageError = error;
                      });
                    });
                  }
                }),
          ],
        );
      });
    },
  );
}

Widget btnWithLoading(_loading) {
  if (!_loading) {
    return new Text(
      "Search",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  } else {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }
}
