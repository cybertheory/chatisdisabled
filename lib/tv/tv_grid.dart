
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

class TvGrid extends StatefulWidget {
  const TvGrid({Key? key}) : super(key: key);

  @override
  _TvGridState createState() => _TvGridState();
}

class _TvGridState extends State<TvGrid> {
  @override
  final tmdbWithCustomLogs = TMDB( //TMDB instance
    ApiKeys('ea292e99d5c7234c5206516845d16f7f', 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYTI5MmU5OWQ1YzcyMzRjNTIwNjUxNjg0NWQxNmY3ZiIsInN1YiI6IjVlYjk2ZjljY2MyNzdjMDAyMTcwNzQ2NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.WNeY2OcrQCngLvee9Mx-uCwg16PvPqfVlwFrqYEZiQE' ),//ApiKeys instance with your keys,
  );
  int _page = 1;
  Widget build(BuildContext context) {
    return FutureBuilder(future: tmdbWithCustomLogs.v3.tv.getAiringToday(page: _page),
      builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot){
        print(snapshot.data);
        int length = snapshot.data!.length;
        return ListView.builder(
            itemCount: length,
            itemBuilder: (context, index){
              if(index==length-1){
                setState(() {
                  _page += 1;
                });
              }
          return Container();
        });
      },
    );
  }
}
