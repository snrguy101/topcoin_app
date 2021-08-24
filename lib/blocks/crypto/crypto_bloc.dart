import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crypto_price/models/coin_model.dart';
import 'package:crypto_price/models/failure_model.dart';
import 'package:crypto_price/respositories/crypto_respository.dart';
import 'package:equatable/equatable.dart';

part 'crypto_event.dart';
part 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRespository _cryptoRespository;
  CryptoBloc({required CryptoRespository cryptoRespository})
      : _cryptoRespository = cryptoRespository,
        super(CryptoState.initial());

  @override
  Stream<CryptoState> mapEventToState(
    CryptoEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is RefreshCoins) {
      yield* getCoin();
    } else if (event is LoadMoreCoins) {
      yield* _mapLoadMoreCoinToState();
    }
    // TODO: implement mapEventToState
  }

  Stream<CryptoState> getCoin({int page = 0}) async* {
    try {
      final coins = [
        if (page != 0) ...state.coins,
        ...await _cryptoRespository.getTopCoin(page: page),
      ];

      yield state.copywith(status: CryptoStatus.loaded, coins: coins);
    } on Failure catch (err) {
      yield state.copywith(failure: err, status: CryptoStatus.error);
    }
  }

  Stream<CryptoState> _mapAppStartedToState() async* {
    yield state.copywith(status: CryptoStatus.loading);
    yield* getCoin();
  }

  Stream<CryptoState> _mapLoadMoreCoinToState() async* {
    final nextpage = state.coins.length ~/ CryptoRespository.perpage;

    yield* getCoin(page: nextpage);
  }
}
