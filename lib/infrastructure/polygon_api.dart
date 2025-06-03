import 'dart:convert';

import 'package:http/http.dart' as http;

class PolygonApi {
  PolygonApi();

  Future<dynamic> getNFTMeta(String? nftAddress, String? tokenId) async{
    if(tokenId != null && nftAddress != null) {
      String apiKey = 'YrSp0cz5_PWFd6_GtMMRDpdDTs2HDusL';
      String url = "polygon-mainnet.g.alchemy.com";
      String path = '/nft/v2/$apiKey/getNFTMetadata';

      Map<String, dynamic> body = { "contractAddress" : nftAddress, "tokenId" : tokenId };

      http.Response response = await http.get(
        Uri.https(url, path, body),
      );

      return jsonDecode(response.body)['metadata'];
    }
  }
}