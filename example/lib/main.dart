import 'dart:math';
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => DataPage(),
      },
    );
  }
}

class DataPickerPage extends StatefulWidget {
  @override
  _DataPickerPageState createState() => _DataPickerPageState();
}

class _DataPickerPageState extends State<DataPickerPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DataPage extends StatefulWidget {
  DataPage({Key key}) : super(key: key);
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<DatatableHeader> _headers = [
    DatatableHeader(
        text: "ID",
        value: "id",
        show: false,
        sortable: true,
        textAlign: TextAlign.right),
    DatatableHeader(
        text: "Name",
        value: "name",
        show: true,
        flex: 2,
        sortable: true,
        editable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "SKU",
        value: "sku",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Category",
        value: "category",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Price",
        value: "price",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Margin",
        value: "margin",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "In Stock",
        value: "in_stock",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Alert",
        value: "alert",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Received",
        value: "received",
        show: true,
        sortable: false,
        sourceBuilder: (value, row) {
          List list = List.from(value);
          return Container(
            child: Column(
              children: [
                Container(
                  width: 85,
                  child: LinearProgressIndicator(
                    value: list.first / list.last,
                  ),
                ),
                Text("${list.first} of ${list.last}")
              ],
            ),
          );
        },
        textAlign: TextAlign.center),
  ];

  Widget _dropContainer(data) {
    List<Widget> _children = data.entries.map<Widget>((entry) {
      Widget w = Row(
        children: [
          Text(entry.key.toString()),
          Spacer(),
          Text(entry.value.toString()),
        ],
      );
      return w;
    }).toList();
    return Container(
      // height: 100,
      child: Column(
        // children: [
        //   Expanded(
        //       child: Container(
        //     color: Colors.red,
        //     height: 50,
        //   )),

        // ],
        children:_children,
      ),
    );
  }

  List<int> _perPages = [10, 20, 50, 100];
  int _total = 100;
  int _currentPerPage = 10;
  List<bool> _expanded; // = List.generate(10, (index) => false);

  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _source = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _selecteds = <Map<String, dynamic>>[];
  //String _selectableKey = "id";

  String _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = true;

  List<Map<String, dynamic>> _generateData({int n: 100}) {
    final List source = List.filled(n, Random.secure());
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _source.length;
    print(i);
    for (int j = 0; j < source.length; j++) {
      //var data = source[j];
      temps.add({
        "id": i,
        "sku": "$i\000$i",
        "name": "Product Product Product Product $i",
        "category": "Category-$i",
        "price": "${i}0.00",
        "cost": "20.00",
        "margin": "${i}0.20",
        "in_stock": "${i}0",
        "alert": "5",
        "received": [i + 20, 150]
      });
      i++;
    }
    return temps;
  }

  _initData() async {
    _expanded = List.generate(_currentPerPage, (index) => false);

    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 3)).then((value) {
      _source.addAll(_generateData(n: 10)); //1000
      setState(() => _isLoading = false);
    });
  }

  _resetData() async {
    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 3)).then((value) {
      _expanded = List.generate(_currentPerPage, (index) => false);

      _source.clear();
      _source.addAll(_generateData(n: _currentPerPage)); //1000
      setState(() => _isLoading = false);
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DATA TABLE"),
        actions: [
          // RaisedButton(onPressed: (){
          //   print(_source);
          // }, child: Text("SHOW")),
        ],
      ),

      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(
                maxHeight: 700,
              ),
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  title: null,
                  actions: [
                    if (_isSearch)
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    _isSearch = false;
                                  });
                                }),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.search), onPressed: () {})),
                      )),
                    if (!_isSearch)
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _isSearch = true;
                            });
                          })
                  ],
                  headers: _headers,
                  source: _source,
                  selecteds: _selecteds,
                  showSelect: _showSelect,
                  autoHeight: false,
                  dropContainer: _dropContainer,
                  onTabRow: (data) {
                    print(data);
                  },
                  onSort: (value) {
                    setState(() {
                      _sortColumn = value;
                      _sortAscending = !_sortAscending;
                      if (_sortAscending) {
                        _source.sort((a, b) =>
                            b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                      } else {
                        _source.sort((a, b) =>
                            a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                      }
                    });
                  },
                  expanded: _expanded,
                  sortAscending: _sortAscending,
                  sortColumn: _sortColumn,
                  isLoading: _isLoading,
                  onSelect: (value, item) {
                    print("$value  $item ");
                    if (value) {
                      setState(() => _selecteds.add(item));
                    } else {
                      setState(
                          () => _selecteds.removeAt(_selecteds.indexOf(item)));
                    }
                  },
                  onSelectAll: (value) {
                    if (value) {
                      setState(() => _selecteds =
                          _source.map((entry) => entry).toList().cast());
                    } else {
                      setState(() => _selecteds.clear());
                    }
                  },
                  footers: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Rows per page:"),
                    ),
                    if (_perPages != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButton(
                            value: _currentPerPage,
                            items: _perPages
                                .map((e) => DropdownMenuItem(
                                      child: Text("$e"),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _currentPerPage = value;
                                _resetData();
                              });
                            }),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child:
                          Text("$_currentPage - $_currentPerPage of $_total"),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                      ),
                      onPressed: () {
                        var _nextSet = _currentPage - _currentPerPage;
                        setState(() {
                          _currentPage = _nextSet > 1 ? _nextSet : 1;
                        });
                      },
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () {
                        var _nextSet = _currentPage + _currentPerPage;

                        setState(() {
                          _currentPage = _nextSet < _total ? _nextSet : _total;
                        });
                      },
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    )
                  ],
                ),
              ),
            ),
          ])),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _initData();
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
