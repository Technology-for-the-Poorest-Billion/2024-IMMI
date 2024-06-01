import 'package:flutter/material.dart';
import 'utils.dart';


class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data'),
        backgroundColor: Color.fromARGB(255, 255, 217, 187),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(context: context, builder: (context) => AlertDialog(
                content: const Text('Clear all data?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No')
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      CycleDataUtils.deleteAllEntry();
                    },
                    child: const Text('Yes')
                  )
                ],
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data cleared successfully!'))
              );
            }, 
            child: Text('Clear All', style: TextStyle(fontSize: 16.0, color: Colors.black)),
          ),
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh))
        ],
      ),
      body: Container(
        child:Column(
          children: [
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
              crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
              children: [
                FutureBuilder<List<TableCycleData>>(
                  future: CycleDataUtils.getAllCycleData(),
                  builder: (BuildContext context, AsyncSnapshot<List<TableCycleData>> snapshot) {
                    if (!snapshot.hasData) {
                      // checking if API has data & if no data then loading bar
                      return Center(child: Text('Empty'));
                    }
                    else {
                      // return data after recieving it in snapshot.
                      return Container(
                          padding: const EdgeInsets.all(5),
                          // Data Table logic and code is in DataClass
                          child: DataClass(dataList: snapshot.data as List<TableCycleData>));
                    }
                  }
                )
              ]
            )
          ],
        ),
      ),
    );
  }
}

class DataClass extends StatelessWidget {
  final List<TableCycleData> dataList;
  const DataClass({Key? key, required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Using scrollView for scrolling and formating
      scrollDirection: Axis.vertical,
      // using FittedBox for fitting complte table in screen horizontally.
      child: FittedBox(
        child: DataTable(
        sortColumnIndex: 1,
        showCheckboxColumn: false,
        border: TableBorder.all(width: 1.0),
        // Data columns as required by APIs data.
        columns: const [
          DataColumn(
            label: Text(
            "Entry Date",
            style: TextStyle(fontSize: 20),
          )),
          DataColumn(
            label: Text(
            "Cycle Start Date",
            style: TextStyle(fontSize: 20),
          )),
          DataColumn(
            label: Text(
            "Cycle Length",
            style: TextStyle(fontSize: 20),
          )),
        ],
        // Main logic and code for geting data and shoing it in table rows.
        rows: dataList.map(
          //maping each rows with datalist data
          (data) => DataRow(
            cells: [
              DataCell(
                Text(
                  data.entryDate,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
              )),
              DataCell(Text(
                data.cycleStartDate,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
              )),
              DataCell(
                Text(
                  data.cycleLength,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
              )),
            ]
          )
        )
      .toList(), // converting at last into list.
    )));
  }
}

class TableCycleData {
  String entryDate, cycleStartDate, cycleLength;

  TableCycleData({
    required this.entryDate,
    required this.cycleStartDate,
    required this.cycleLength
  });

  Map<String, dynamic> toMap() {
    return {
      'Entry Date': entryDate,
      'Cycle Start Date': cycleStartDate,
      'Cycle Length': cycleLength
    };
  }
}