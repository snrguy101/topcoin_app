import 'package:crypto_price/blocks/crypto/crypto_bloc.dart';
import 'package:crypto_price/models/coin_model.dart';
import 'package:crypto_price/respositories/crypto_respository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Top Coins"),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Theme.of(context).primaryColor,
              Colors.grey[900]!,
            ])),
        child: BlocBuilder<CryptoBloc, CryptoState>(
          builder: (context, state) {
            switch (state.status) {
              case CryptoStatus.loaded:
                return RefreshIndicator(
                  color: Theme.of(context).accentColor,
                  onRefresh: () async {
                    print("Refresh");
                    context.read<CryptoBloc>().add(RefreshCoins());
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) =>
                        _onScrollNotification(notification),
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.coins.length,
                        itemBuilder: (BuildContext context, int index) {
                          final coin = state.coins[index];
                          return ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              coin.fullname,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              coin.name,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            trailing: Text(
                              '${coin.price.toStringAsFixed(4)}',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }),
                  ),
                );
              case CryptoStatus.error:
                return Center(
                  child: Text(
                    state.failure.messsage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 18.0,
                    ),
                  ),
                );

              default:
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.tealAccent),
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  bool _onScrollNotification(ScrollNotification notif) {
    if (notif is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      context.read<CryptoBloc>().add(LoadMoreCoins());
      print("The End");
    }
    return false;
  }
}
