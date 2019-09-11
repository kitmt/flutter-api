import 'package:flutter/material.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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
    final response = await http.get("https://cmfiflutterapp.s3-ap-southeast-2.amazonaws.com/latest.json");
    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data) {
          _list.add(User.fromJson(i));
          loading = false;


        }
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
      if (f.Ctry.contains(text) ||
          f.PeopNameInCountry.toString().contains(text)) _search.add(f);
    });

    setState(() {});
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
                              b.Ctry,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(b.PeopNameInCountry),
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
                              a.Ctry,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(a.PeopNameInCountry),
                          ],
                        )),
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
        title: Text(user.PeopNameInCountry),
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
                      image: NetworkImage(user.PhotoAddress,
                          scale: 1.5),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  user.Ctry,
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                ),
                Text(
                  user.PeopNameInCountry,
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
                        user.Population.toString(),
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
                        user.BibleStatus.toString(),
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
              user.Ctry,
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
              user.PeopNameInCountry,
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
              user.RegionName,
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
              user.AffinityBloc,
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
              user.PrimaryLanguageName.toString(),
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
              user.PrimaryReligion,
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
              user.LeastReached,
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
              user.Longitude.toString(),
              style: TextStyle(fontSize: 14.0),
            ),
          ),
          ListTile(
            title: Text(
              "Latitude",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              user.Latitude.toString(),
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
              image: NetworkImage(user.MapAddress.toString()),
            ),
          )
        ],
      ),
    );
  }
}

class User {
  final String Ctry;
  final String PeopNameInCountry;
  final int Population;
  final String LeastReached;
  final String PrimaryLanguageName;
  final int BibleStatus;
  final String PrimaryReligion;
  final String Continent;
  final String RegionName;
  final String AffinityBloc;
  final double Longitude;
  final double Latitude;
  final String PeopleCluster;
  final String Frontier;
  final int WorkersNeeded;
  final MapAddress;
  final PhotoAddress;

  User(
      {this.Ctry,
        this.PeopNameInCountry,
        this.Population,
        this.PrimaryLanguageName,
        this.BibleStatus,
        this.PrimaryReligion,
        this.Continent,
        this.RegionName,
        this.AffinityBloc,
        this.Longitude,
        this.Latitude,
        this.LeastReached,
        this.PeopleCluster,
        this.Frontier,
        this.WorkersNeeded,
        this.MapAddress,
        this.PhotoAddress});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
        Ctry: json['Ctry'],
        PeopNameInCountry: json['PeopNameInCountry'],
        Population: json['Population'],
        PrimaryLanguageName: json['PrimaryLanguageName'],
        BibleStatus: json['BibleStatus'],
        PrimaryReligion: json['PrimaryReligion'],
        Continent: json['Continent'],
        RegionName: json['RegionName'],
        AffinityBloc: json['AffinityBloc'],
        Longitude: json['Longitude'],
        Latitude: json['Latitude'],
        LeastReached: json['LeastReached'],
        PeopleCluster: json['PeopleCluster'],
        Frontier: json['Frontier'],
        WorkersNeeded: json['WorkersNeeded'],
        MapAddress: json['MapAddress'],
        PhotoAddress: json['PhotoAddress']);
  }


}
