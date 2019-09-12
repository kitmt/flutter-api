mport 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Api extends StatefulWidget {
  @override
  ApiScreenState createState() => ApiScreenState();
}

class ApiScreenState extends State<Api> {
  List<User> _list = [];
  List<User> _search = [];
  var loading = false;

  Future<Null> fetchData() async {
    setState(() {
      loading = true;
    });
    _list.clear();
    final response = await http.get(
        "https://joshuaproject.net/api/v2/people_groups?LeastReached=Y&limit=400&page=12&api_key=aWye9lV20QtF");
    if (response.statusCode == 200) {
      ResponseModel model = responseModelFromJson(response.body);
      setState(() {
        _list.addAll(model.data);
        loading = false;
      });
    }
  }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _list.forEach((f) {
      if (f.ctry.contains(text) ||
          f.peopNameInCountry.toString().contains(text)) _search.add(f);
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.blue,
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: TextField(
                    controller: controller,
                    onChanged: onSearch,
                    decoration: InputDecoration(
                        hintText: "Search", border: InputBorder.none),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      controller.clear();
                      onSearch('');
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ),
              ),
            ),
            loading
                ? Center(
              heightFactor: 10.0,
              child: CircularProgressIndicator(),
            )
                : Expanded(
              child: _search.length != 0 || controller.text.isNotEmpty
                  ? ListView.builder(
                itemCount: _search.length,
                itemBuilder: (context, i) {
                  final b = _search[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(_search[i])));
                      debugPrint('TopNav');
                    },
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              b.ctry,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(b.peopNameInCountry),
                          ],
                        )),
                  );
                },
              )
                  : ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, i) {
                  final a = _list[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(_list[i])));
                      debugPrint('BottomNav');
                    },
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              a.ctry,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(a.peopNameInCountry),
                          ],
                        ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.peopNameInCountry),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [
                      0.5,
                      0.9
                    ],
                    colors: [
                      Colors.blue,
                      Colors.blue,
                    ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image(
                      image: NetworkImage(user.photoAddress, scale: 1.5),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  user.ctry,
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                ),
                Text(
                  user.peopNameInCountry,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                )
              ],
            ),
          ),
          Container(
            height: 70,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.deepPurpleAccent,
                    child: ListTile(
                      title: Text(
                        user.population.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      subtitle: Text(
                        "Population",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.red,
                    child: ListTile(
                      title: Text(
                        user.bibleStatus.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      subtitle: Text(
                        "Bible Status",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          ListTile(
            title: Text(
              "Bible Translation Status",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              '0 = Unspecfied\n1 = Translation needed\n2 = Translation started\n3 = Portions\n4 = New Testament\n5 = Complete Bible',
              style: TextStyle(fontSize: 12.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Country",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              user.ctry,
              style: TextStyle(fontSize: 15.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'People Group',
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              user.peopNameInCountry,
              style: TextStyle(fontSize: 15.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Region Name",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              user.regionName,
              style: TextStyle(fontSize: 15.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Affinity Bloc",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              user.affinityBloc,
              style: TextStyle(fontSize: 15.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Primary Language ",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              user.primaryLanguageName.toString(),
              style: TextStyle(fontSize: 15.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Religion",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              user.primaryReligion,
              style: TextStyle(fontSize: 15.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Location In Country",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              user.leastReached,
              style: TextStyle(fontSize: 14.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Longtitude",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              user.longitude.toString(),
              style: TextStyle(fontSize: 14.0),
            ),
          ),
          ListTile(
            title: Text(
              "Latitude",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              user.latitude.toString(),
              style: TextStyle(fontSize: 14.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Literacy ",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: NetworkImage(user.mapAddress.toString()),
            ),
          )
        ],
      ),
    );
  }
}

// To parse this JSON data, do
//
//     final responseModel = responseModelFromJson(jsonString);

//import 'dart:convert';

ResponseModel responseModelFromJson(String str) =>
    ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) =>     json.encode(data.toJson());

class ResponseModel {
  Meta meta;
  List<User> data;
  Status status;

  ResponseModel({
    this.meta,
    this.data,
    this.status,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>     ResponseModel(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    data: json["data"] == null
        ? null
        : List<User>.from(json["data"].map((x) => User.fromJson(x))),
    status: json["status"] == null ? null : Status.fromJson(json["status"]),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta == null ? null : meta.toJson(),
    "data": data == null
        ? null
        : List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status == null ? null : status.toJson(),
  };
}

class User {
  String ctry;
  String peopNameInCountry;
  int population;
  String leastReached;
  String primaryLanguageName;
  int bibleStatus;
  String primaryReligion;
  String continent;
  String regionName;
  String affinityBloc;
  double longitude;
  double latitude;
  String peopleCluster;
  String frontier;
  int workersNeeded;
  String photoAddress;
  String mapAddress;

  User({
    this.ctry,
    this.peopNameInCountry,
    this.population,
    this.continent,
    this.regionName,
    this.affinityBloc,
    this.peopleCluster,
    this.leastReached,
    this.frontier,
    this.workersNeeded,
    this.primaryLanguageName,
    this.bibleStatus,
    this.primaryReligion,
    this.photoAddress,
    this.mapAddress,
    this.longitude,
    this.latitude,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    ctry: json["Ctry"] == null ? null : json["Ctry"],
    peopNameInCountry: json["PeopNameInCountry"] == null
        ? null
        : json["PeopNameInCountry"],
    population: json["Population"] == null ? null : json["Population"],
    continent: json["Continent"] == null ? null : json["Continent"],
    regionName: json["RegionName"] == null ? null : json["RegionName"],
    affinityBloc:
    json["AffinityBloc"] == null ? null : json["AffinityBloc"],
    peopleCluster:
    json["PeopleCluster"] == null ? null : json["PeopleCluster"],
    leastReached:
    json["LeastReached"] == null ? null : json["LeastReached"],
    frontier: json["Frontier"] == null ? null : json["Frontier"],
    workersNeeded:
    json["WorkersNeeded"] == null ? null : json["WorkersNeeded"],
    primaryLanguageName: json["PrimaryLanguageName"] == null
        ? null
        : json["PrimaryLanguageName"],
    bibleStatus: json["BibleStatus"] == null ? null : json["BibleStatus"],
    primaryReligion:
    json["PrimaryReligion"] == null ? null : json["PrimaryReligion"],
    photoAddress:
    json["PhotoAddress"] == null ? null : json["PhotoAddress"],
    mapAddress: json["MapAddress"] == null ? null : json["MapAddress"],
    longitude:
    json["Longitude"] == null ? null : json["Longitude"].toDouble(),
    latitude: json["Latitude"] == null ? null : json["Latitude"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Ctry": ctry == null ? null : ctry,
    "PeopNameInCountry":
    peopNameInCountry == null ? null : peopNameInCountry,
    "Population": population == null ? null : population,
    "Continent": continent == null ? null : continent,
    "RegionName": regionName == null ? null : regionName,
    "AffinityBloc": affinityBloc == null ? null : affinityBloc,
    "PeopleCluster": peopleCluster == null ? null : peopleCluster,
    "LeastReached": leastReached == null ? null : leastReached,
    "Frontier": frontier == null ? null : frontier,
    "WorkersNeeded": workersNeeded == null ? null : workersNeeded,
    "PrimaryLanguageName":
    primaryLanguageName == null ? null : primaryLanguageName,
    "BibleStatus": bibleStatus == null ? null : bibleStatus,
    "PrimaryReligion": primaryReligion == null ? null : primaryReligion,
    "PhotoAddress": photoAddress == null ? null : photoAddress,
    "MapAddress": mapAddress == null ? null : mapAddress,
    "Longitude": longitude == null ? null : longitude,
    "Latitude": latitude == null ? null : latitude,
  };
}

class Meta {
  Pagination pagination;

  Meta({
    this.pagination,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination == null ? null : pagination.toJson(),
  };
}

class Pagination {
  int totalCount;
  int totalPages;
  int currentPage;
  int limit;

  Pagination({
    this.totalCount,
    this.totalPages,
    this.currentPage,
    this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalCount: json["total_count"] == null ? null : json["total_count"],
    totalPages: json["total_pages"] == null ? null : json["total_pages"],
    currentPage: json["current_page"] == null ? null : json["current_page"],
    limit: json["limit"] == null ? null : json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "total_count": totalCount == null ? null : totalCount,
    "total_pages": totalPages == null ? null : totalPages,
    "current_page": currentPage == null ? null : currentPage,
    "limit": limit == null ? null : limit,
  };
}

class Status {
  String message;
  int statusCode;

  Status({
    this.message,
    this.statusCode,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    message: json["message"] == null ? null : json["message"],
    statusCode: json["status_code"] == null ? null : json["status_code"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "status_code": statusCode == null ? null : statusCode,
  };
}