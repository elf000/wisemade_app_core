import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';

// AQUI: escondemos a classe Transaction exportada pelo web3dart
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart' hide Transaction;

import 'package:wisemade_app_core/models/exchange.dart';
import 'package:wisemade_app_core/models/my_coin.dart';
import 'package:wisemade_app_core/models/portfolio_snapshot.dart';
import 'package:wisemade_app_core/models/transaction.dart'; // modelo local Transaction

import '../models/coin.dart';
import '../models/hathor_wallet.dart';
import '../models/news.dart';
import '../models/asset_holder.dart';
import '../models/user.dart';
import '../models/video.dart';

class WisemadeApi {
  static String url = 'https://api.wisemade.io';
  // static String url = 'http://192.168.1.6:4000';

  final BuildContext context;

  WisemadeApi(this.context);

  Future<List<Coin>> fetchFamousCoins({String? fiatSymbol}) async {
    return _get(
      '/coins/famous',
      body: {'fiat_symbol': fiatSymbol},
    ).then<List<Coin>>((json) {
      return json.map<Coin>((coin) => Coin.fromJson(coin)).toList();
    });
  }

  Future<List<Coin>> fetchTrendingCoins({String? fiatSymbol}) async {
    return _get(
      '/coins/trending',
      body: {'fiat_symbol': fiatSymbol},
    ).then<List<Coin>>((json) =>
        json.map<Coin>((record) => Coin.fromJson(record['coin'])).toList());
  }

  Future<List<Coin>> fetchTopGainersCoins({String? fiatSymbol}) async {
    return _get(
      '/coins/top_gainers',
      body: {'fiat_symbol': fiatSymbol},
    ).then<List<Coin>>((json) {
      List<Coin> coins = json
          .map<Coin>((record) => Coin.fromJson(record['coin']))
          .toList();
      coins.sort((a, b) =>
      a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h) *
          -1);
      return coins;
    });
  }

  Future<List<Coin>> fetchTopEngagedCoins({String? fiatSymbol}) async {
    return _get(
      '/coins/top_engaged',
      body: {'fiat_symbol': fiatSymbol},
    ).then<List<Coin>>((json) {
      List<Coin> coins = json
          .map<Coin>((record) => Coin.fromJson(record['coin']))
          .toList();
      coins.sort((a, b) =>
      a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h) *
          -1);
      return coins;
    });
  }

  Future<List<Coin>> fetchCoinsByCategory(
      String category, {
        String? fiatSymbol,
      }) async {
    return _get(
      '/coins/by_category',
      body: {'category': category, 'fiat_symbol': fiatSymbol},
    ).then<List<Coin>>((json) {
      List<Coin> coins =
      json.map<Coin>((record) => Coin.fromJson(record)).toList();
      coins.sort((a, b) =>
      a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h) *
          -1);
      return coins;
    });
  }

  Future<List<Coin>> fetchPortfolioCoins() async {
    return _get('/portfolios/coins_list').then<List<Coin>>((json) {
      return json['coins'].map<Coin>((coin) => Coin.fromJson(coin)).toList();
    });
  }

  Future<Map<String, dynamic>> fetchHathorWalletCoins(
      int page, {
        int perPage = 10,
      }) async {
    return _get(
      '/hathor_wallets/coins',
      body: {"page": page, "per_page": perPage},
    ).then<Map<String, dynamic>>((json) {
      return {
        "coins":
        json['coins'].map<MyCoin>((c) => MyCoin.fromFullJson(c)).toList(),
        "count": json['meta']['count'],
      };
    });
  }

  Future<List<Coin>> fetchFavoriteCoins({String? fiatSymbol}) async {
    return _get(
      '/users/favorite_coins',
      body: {'fiat_symbol': fiatSymbol},
    ).then<List<Coin>>((json) {
      return json.map<Coin>((coin) => Coin.fromJson(coin)).toList();
    });
  }

  Future<List<Exchange>> fetchExchanges() async {
    return _get('/exchanges').then<List<Exchange>>((json) {
      return json
          .map<Exchange>((exchange) => Exchange.fromJson(exchange))
          .toList();
    });
  }

  Future<Map<String, dynamic>> fetchCoinTransactions(
      MyCoin coin,
      int page, {
        int? assetHolderId,
      }) async {
    return _get(
      '/transactions',
      body: {
        "page": page,
        "coin_id": coin.id,
        "asset_holder_id": assetHolderId
      },
    ).then<Map<String, dynamic>>((json) {
      return {
        "transactions": json['transactions']
            .map<Transaction>((t) => Transaction.fromJson(t))
            .toList(),
        "count": json['meta']['count'],
      };
    });
  }

  Future<Map<String, dynamic>> fetchPortfolioCoinsSummary(
      int page, {
        int? exchangePortfolioId,
        int perPage = 10,
      }) async {
    return _get(
      '/portfolios/coins_summary',
      body: {
        "page": page,
        "per_page": perPage,
        "exchange_portfolio": exchangePortfolioId
      },
    ).then<Map<String, dynamic>>((json) {
      return {
        "coins": json['coins']
            .map<MyCoin>((c) => MyCoin.fromFullJson(c))
            .toList(),
        "count": json['meta']['count'],
      };
    });
  }

  Future<List<News>> fetchCoinNews(
      String slug, {
        String lang = 'en',
      }) async {
    return _get(
      "/coins/$slug/news",
      body: {'lang': lang},
    ).then<List<News>>((json) {
      return json
          .where((record) => record['image'] != null)
          .map<News>((record) => News.fromJson(record))
          .toList();
    });
  }

  // >**CORREÇÃO AQUI**: transformamos em async/await para poder usar rethrow no catch
  Future<Coin> fetchCoin(
      String slug, {
        String lang = 'en',
        String? fiatSymbol,
      }) async {
    try {
      final json = await _get(
        "/coins/$slug",
        body: {'lang': lang, 'fiat_symbol': fiatSymbol},
      );
      return Coin.fromJson(json);
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<Coin> fetchCoinOfTheDay({String? fiatSymbol}) async {
    return _get(
      '/coins/coin_of_the_day',
      body: {'fiat_symbol': fiatSymbol},
    ).then<Coin>((json) {
      return Coin.fromJson(json);
    });
  }

  Future<List<News>> fetchPortfolioNews({String lang = 'en'}) async {
    return _get(
      '/portfolios/news',
      body: {'lang': lang},
    ).then<List<News>>((json) {
      if (json != null) {
        return json
            .where((record) => record['image'] != null)
            .map<News>((record) => News.fromJson(record))
            .toList();
      } else {
        return [];
      }
    });
  }

  Future<PortfolioSnapshot> fetchPortfolioSnapshot({
    int? exchangePortfolioId,
  }) {
    return _get(
      '/portfolios',
      body: {"exchange_portfolio": exchangePortfolioId},
    ).then((json) {
      return PortfolioSnapshot.fromJson(json['snapshot']);
    });
  }

  Future<num> fetchCoinPrice(Coin coin) {
    return _get("/coins/${coin.id}/price").then((price) {
      return price;
    });
  }

  Future<List<AssetHolder>> fetchPortfolioExchanges() {
    return _get('/portfolios').then((json) {
      return json['exchangePortfolios']
          .map<AssetHolder>((record) => AssetHolder.fromJson(record))
          .toList();
    });
  }

  Future<HathorWallet?> fetchHathorWallet() {
    return _get('/portfolios').then((json) {
      if (json['hathorWallet'] == null) {
        return null;
      }
      return HathorWallet.fromJson(jsonDecode(json['hathorWallet']));
    });
  }

  Future<List<Coin>> searchCoins({
    String? query,
    String? category,
    Exchange? exchange,
    int? page = 1,
    int? perPage = 10,
    Function? callback,
  }) async {
    return _get(
      "/coins",
      body: {
        "query": query,
        "category": category,
        "page": page,
        "per_page": perPage,
        "exchange_id": exchange?.id
      },
      callback: callback,
    ).then<List<Coin>>(
          (json) => json.map<Coin>((record) => Coin.fromJson(record)).toList(),
    );
  }

  Future<List<Coin>> fetchExchangeCoins(
      Exchange exchange, {
        String? query,
      }) async {
    return _get(
      "/exchanges/${exchange.id}/coins",
      body: {"query": query},
    ).then<List<Coin>>(
          (json) => json.map<Coin>((record) => Coin.fromJson(record)).toList(),
    );
  }

  Future<List<Video>> fetchVideos({String lang = 'pt'}) async {
    return _get(
      "/youtube/videos",
      body: {"lang": lang},
    ).then<List<Video>>(
          (json) => json.map<Video>((record) => Video.fromJson(record)).toList(),
    );
  }

  Future fetchInfluencers({String lang = 'pt'}) async {
    return _get(
      "/youtube/influencers",
      body: {"lang": lang},
    );
  }

  Future fetchPerformanceReport() async {
    return _get("/portfolios/performance_report");
  }

  Future<List<Video>> fetchChannelVideos(String channelId) async {
    return _get(
      "/youtube/channel_videos",
      body: {"channel_id": channelId},
    ).then<List<Video>>(
          (json) => json.map<Video>((record) => Video.fromJson(record)).toList(),
    );
  }

  Future addTransaction(Map<String, dynamic> payload) async {
    return _post('/transactions', body: payload);
  }

  Future addWallet(Map<String, dynamic> payload) {
    return _post('/wallets', body: payload);
  }

  Future setupUser(Map<String, dynamic> payload) async {
    return _put('/users/setup', body: payload);
  }

  Future setupFiat(String fiat) async {
    return _put('/users/set_fiat', body: {"fiat": fiat});
  }

  Future toggleFavorite(Coin coin) async {
    return _post('/users/toggle_favorite', body: {"coin_id": coin.id});
  }

  Future<User> fetchCurrentUser() async {
    return _get("/users/current").then<User>((json) {
      if (json['errors'] != null) throw Exception(json['errors']);
      return User.fromJson(json);
    });
  }

  Future signIn(Map<String, String> body) async {
    final response = await http.post(
      Uri.parse(url).replace(path: '/auth/sign_in'),
      body: body,
      headers: {'Source': 'Flutter App'},
    );

    if (response.statusCode == 200) {
      return response.headers;
    } else {
      throw json.decode(response.body)['errors'][0];
    }
  }

  Future signUp(Map<String, String> body) async {
    final response = await http.post(
      Uri.parse(url).replace(path: '/auth'),
      body: body,
      headers: {'Source': 'Flutter App'},
    );

    if (response.statusCode == 200) {
      return response.headers;
    } else {
      throw json.decode(response.body)['errors'];
    }
  }

  Future<bool> doesEmailExist(String email) async {
    final response = await http.post(
      Uri.parse(url).replace(path: '/users/email_exists'),
      body: {"email": email},
    );

    if (response.statusCode == 200) {
      return response.body == "true";
    } else {
      throw json.decode(response.body)['error'];
    }
  }

  /// Tornamos `payload` NÃO‐NULO e removemos `!` redundantes.
  Future signInWithGoogle(GoogleSignInAccount payload) async {
    Map<String, String> body = {
      'social_auth[provider]': 'google_oauth2',
      'social_auth[uid]': payload.email,
      'social_auth[info][name]': payload.displayName ?? '',
      'social_auth[info][email]': payload.email,
    };

    return _socialCallback(body);
  }

  /// Tornamos `payload` NÃO‐NULO e removemos `!` redundantes.
  Future signInWithApple(AuthorizationCredentialAppleID payload) async {
    Map<String, String> body = {
      'social_auth[provider]': 'apple.com',
      'social_auth[uid]': payload.email ?? '',
      'social_auth[apple_signin_id]': payload.userIdentifier ?? '',
      'social_auth[info][name]':
      payload.givenName != null ? "${payload.givenName} ${payload.familyName}" : '',
      'social_auth[info][email]': payload.email ?? '',
      'social_auth[info][id_token]': payload.identityToken ?? '',
    };

    return _socialCallback(body);
  }

  Future signInWithMetamask(
      IWeb3App client,
      SessionData session,
      String address,
      ) async {
    String nonce = await _getWeb3Nonce(address);

    final signature = await client.request(
      topic: session.topic,
      chainId: 'eip155:1',
      request: SessionRequestParams(
        method: 'personal_sign',
        params: [nonce, address],
      ),
    );

    return _authenticateWeb3(address, signature);
  }

  Future deleteTransaction(Transaction transaction) async {
    return _delete("/transactions/${transaction.id}");
  }

  Future deleteExchangePortfolio(int exchangePortfolioId) async {
    return _delete("/exchange_portfolios/$exchangePortfolioId");
  }

  Future deleteWallet(int walletId) async {
    return _delete("/wallets/$walletId");
  }

  Future deleteAccount() async {
    return _delete('/users/destroy_current');
  }

  Future fetchExchangePortfolio(int exchangePortfolioId) async {
    final json = await _get("/exchange_portfolios/$exchangePortfolioId");
    return AssetHolder.fromJson(json);
  }

  Future fetchWallet(int walletId) async {
    final json = await _get("/wallets/$walletId");
    return AssetHolder.fromJson(json);
  }

  Future _getWeb3Nonce(String address) {
    return http
        .post(
      Uri.parse(url).replace(path: '/web3/nounce'),
      body: {'public_address': address},
    )
        .then((response) => response.body);
  }

  Future _authenticateWeb3(String address, String signature) {
    return http
        .post(
      Uri.parse(url).replace(path: '/web3/auth'),
      body: {'public_address': address, 'signature': signature},
    )
        .then((response) => response.headers);
  }

  Future _socialCallback(Map<String, String> body) =>
      http
          .post(
        Uri.parse(url).replace(path: '/social/callback'),
        body: body,
      )
          .then((response) => response.headers);

  Future _get(
      String path, {
        Map<String, dynamic>? body,
        Function? callback,
        bool shouldBeAuthenticated = true,
      }) async {
    body?.removeWhere((key, value) => value == null);
    Map<String, String>? parsedBody =
    body?.map((key, value) => MapEntry(key, value.toString()));

    Map<String, String>? headers = await _getAuthHeaders(shouldBeAuthenticated);

    return http
        .get(
      Uri.parse(url).replace(path: path, queryParameters: parsedBody),
      headers: headers,
    )
        .then((response) async {
      try {
        await _updateAuthHeaders(response.headers);
        if (callback != null) callback(response);
        return jsonDecode(response.body);
      } on FormatException catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  Future _post(
      String path, {
        Map<String, dynamic>? body,
      }) async {
    body?.removeWhere((key, value) => value == null);
    Map<String, String>? parsedBody =
    body?.map((key, value) => MapEntry(key, value.toString()));
    Map<String, String>? headers = await _getAuthHeaders(true);

    return http
        .post(
      Uri.parse(url).replace(path: path),
      headers: headers,
      body: parsedBody,
    )
        .then((response) async {
      await _updateAuthHeaders(response.headers);
      if (response.statusCode == 422) {
        throw UnprocessableEntity(response.body.toString());
      }
      return jsonDecode(response.body);
    });
  }

  Future _put(
      String path, {
        Map<String, dynamic>? body,
      }) async {
    body?.removeWhere((key, value) => value == null);
    Map<String, String>? parsedBody =
    body?.map((key, value) => MapEntry(key, value.toString()));
    Map<String, String>? headers = await _getAuthHeaders(true);

    return http
        .put(
      Uri.parse(url).replace(path: path),
      headers: headers,
      body: parsedBody,
    )
        .then((response) async {
      await _updateAuthHeaders(response.headers);
      if (response.statusCode == 422) {
        throw UnprocessableEntity(response.body.toString());
      }
      return jsonDecode(response.body);
    });
  }

  Future _delete(String path) async {
    Map<String, String>? headers = await _getAuthHeaders(true);
    return http.delete(
      Uri.parse(url).replace(path: path),
      headers: headers,
    );
  }

  Future<Map<String, String>?> _getAuthHeaders(
      bool shouldBeAuthenticated,
      ) async {
    var session = SessionManager();
    bool isLoggedIn = (await session.get("isLoggedIn")) ?? false;

    if (shouldBeAuthenticated) {
      if (isLoggedIn) {
        String token = await session.get("access-token");
        String client = await session.get("client");
        String expiry = (await session.get("expiry")).toString();
        String uid = await session.get("uid");

        return {
          'access-token': token,
          'client': client,
          'expiry': expiry,
          'uid': uid,
        };
      } else {
        if (!context.mounted) return {};
        Navigator.of(context).pushNamedAndRemoveUntil('/intro', (route) => false);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> _updateAuthHeaders(Map<String, dynamic> headers) async {
    var session = SessionManager();

    if (headers['access-token'] != "" && headers['access-token'] != null) {
      await Future.wait([
        session.set('isLoggedIn', true),
        session.set('uid', headers['uid']),
        session.set('access-token', headers['access-token']),
        session.set('expiry', headers['expiry']),
        session.set('client', headers['client']),
      ]);
    }
  }
}

class UnprocessableEntity implements Exception {
  String cause;
  UnprocessableEntity(this.cause);
}