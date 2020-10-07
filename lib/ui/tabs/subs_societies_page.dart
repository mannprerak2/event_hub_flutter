import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/ui/tiles/society_tile_left.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class SubsSocietiesPage extends StatelessWidget {
  static const int batchSize = 2;
  static bool moreAvailable = true;

  @override
  Widget build(BuildContext context) {
    GlobalBloc globalBloc = GlobalProvider.of(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffB54646),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 12.0,
                spreadRadius: 4.0,
              )
            ],
          ),
          width: width > 600 ? 600 : width,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Subscribed Societies"),
            ),
            body: Container(
              color: Colors.white,
              child: PagewiseListView(
                pageSize: batchSize,
                pageFuture: (pageIndex) {
                  return Future<List<Map<String, dynamic>>>(() async {
                    print('db fetch...');
                    //fetch
                    List<Map<String, dynamic>> documents =
                        await globalBloc.sqlite.getSubs(batchSize, pageIndex);

                    return documents;
                  });
                },
                noItemsFoundBuilder: (context) {
                  return Text("No Subscribed Socieites");
                },
                itemBuilder: (context, entry, i) {
                  return SocietyTileLeft.fromMap(entry);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
