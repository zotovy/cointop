import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:fluttercrypto/data/crypto_data.dart';
// import 'package:fluttercrypto/modules/crypto_presenter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currencies;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  

  @override
   void initState() {
    super.initState();
    refreshListCoins();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Crypto App"),
          elevation: 5.0,
        ),
        body: CupertinoPageScaffold(
          child: RefreshIndicator(
            key: refreshKey,
            child: FutureBuilder<List<Crypto>>(
              future: _currencies,
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  List<Crypto> coins = snapshot.data;
                  return ListView(
                    children: coins.map((coin) => Column (
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _getRowWithDivider(coin),
                      ]
                    )).toList()
                );
                }
                else {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    )
                  );
                }
              }),
            onRefresh: refreshListCoins
          )
        )
    );
  }

  Widget _getRowWithDivider(coin) {
    var children = <Widget>[
      new Padding(
          padding: new EdgeInsets.all(10.0),
          child: _getListItemUi(coin)
      ),
      new Divider(height: 5.0),
    ];

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  ListTile _getListItemUi(Crypto coin) {
    return new ListTile(
      leading: new FadeInImage(placeholder: new AssetImage('assets/2.0x/undefined.png'), image: new NetworkImage("https://raw.githubusercontent.com/atomiclabs/cryptocurrency-icons/master/128/color/${coin.symbol.toLowerCase()}.png")),
      title: new Text(coin.name,
          style: new TextStyle(fontWeight: FontWeight.bold)),
      subtitle:
      _getSubtitleText(coin.price, coin.changed_history),
      isThreeLine: true,
    );
  }

  Widget _getSubtitleText(String priceUSD, String percentageChange) {
    TextSpan priceTextWidget = new TextSpan(
        text: "\$$priceUSD\n", style: new TextStyle(color: Colors.black));
    String percentageChangeText = "$percentageChange%";
    TextSpan percentageChangeTextWidget;

    if (double.parse(percentageChange) > 0) {
      percentageChangeTextWidget = new TextSpan(
          text: percentageChangeText,
          style: new TextStyle(color: Colors.green));
    } else {
      percentageChangeTextWidget = new TextSpan(
          text: percentageChangeText, style: new TextStyle(color: Colors.red));
    }

    return new RichText(
        text: new TextSpan(
            children: [priceTextWidget, percentageChangeTextWidget]));
  }

  Future<List<Crypto>> fetchCoins() async {
    final String url = "https://api.coinmarketcap.com/v1/ticker/?limit=50";
    final response = await http.get(url);
    List coins = json.decode(response.body);
    return coins.map((coin) => new Crypto.fromJson(coin)).toList();
  }

  Future<Null> refreshListCoins() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      _currencies = fetchCoins();
    });

    return null;
  }


}





class Crypto {
  String name;
  String price;
  String changed_history;
  String symbol;

  Crypto({this.name, this.price, this.changed_history, this.symbol});

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      name: json['name'],
      symbol: json['symbol'],
      price: json['price_usd'],
      changed_history: json['percent_change_1h'],
    );
  }
}
