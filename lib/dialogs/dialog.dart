import 'package:flutter/material.dart';
import 'package:flutter_puzzle/database/database_helper.dart';
import 'package:flutter_puzzle/models/rank.dart';

//显示排行榜dialog
showRankDialog(BuildContext context, TickerProvider tickerProvider, List<String> levels){
	showDialog(
			context: context,
			builder: (context){
				TabController tabController = TabController(length: levels.length, vsync: tickerProvider);
				return AlertDialog(
						content: Column(
							mainAxisSize: MainAxisSize.min,
							children: <Widget>[
								Text("排行榜", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 18),),
								//		Container(height: 10,),
								TabBar(
									controller: tabController,
									tabs: levels.map((e){
										//	return Text(e, style: TextStyle(color: Colors.black, fontSize: 16),);
										return Tab(child: Text(e, style: TextStyle(color: Colors.black, fontSize: 16),),);
									}).toList(),
								),
								Container(
									//			color: Colors.green,
									width: MediaQuery.of(context).size.width,
									height: 100,
									child: TabBarView(
										controller: tabController,
										children: <Widget>[
											_rank(1),
											_rank(2),
											_rank(3),
										],
									),
								),
								RaisedButton(
									onPressed: (){
										Navigator.of(context).pop();
									},
									child: Text("确定"),
								),
								FlatButton(
									padding: EdgeInsets.all(0),
									onPressed: (){
										DatabaseHelper.instance.delete();
										Navigator.of(context).pop();
									},
									child: Text("清空排行榜", style: TextStyle(color: Colors.blue),),
								),
							],
						)
				);
			}
	);
}

Widget _rank(int level){
	return Column(
		mainAxisSize: MainAxisSize.min,
		children: <Widget>[
			Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: <Widget>[
					Expanded(child: Text("名次", textAlign: TextAlign.center,)),
					Expanded(child: Text("昵称", textAlign: TextAlign.center,)),
					Expanded(child: Text("成绩", textAlign: TextAlign.center,)),
					Expanded(flex: 2,child: Text("日期", textAlign: TextAlign.center,)),
				],
			),
			FutureBuilder<List<Rank>>(
					future: DatabaseHelper.instance.searchThree(level),
					builder: (context, snapshot){
						if(snapshot.connectionState == ConnectionState.done){
							if(snapshot.hasData){
								return Column(
									mainAxisSize: MainAxisSize.min,
									children: snapshot.data.map((e){
										return Row(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children: <Widget>[
												Expanded(child: Text((snapshot.data.indexOf(e) + 1).toString(), textAlign: TextAlign.center,)),
												Expanded(child: Text(e.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,)),
												Expanded(child: Text(Duration(milliseconds: e.score).toString().substring(2, 7), textAlign: TextAlign.center,)),
												Expanded(flex: 2, child: Text(e.time.substring(0, 10), textAlign: TextAlign.center,)),
											],
										);
									}).toList(),
								);
							}else{
								return Center(
									child: Text("没有数据！"),
								);
							}
						}else{
							return Container();
						}
					}),
		],
	);
}