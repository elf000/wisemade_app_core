// lib/utils/auth_helper.dart

import 'dart:convert';
import 'package:crypto/crypto.dart';

/// COMENTÁRIO: Monta a assinatura HMAC-SHA256 conforme especificação Foxbit.
///   - [secret]: foxbitApiSecret
///   - [timestamp]: timestamp em segundos (String).
///   - [method]: verbo HTTP em uppercase (ex: "POST", "GET").
///   - [path]: caminho da rota (ex: "/sub_member").
///   - [body]: corpo da requisição em JSON (pode ser string vazia se GET).
String generateFoxbitSignature({
  required String secret,
  required String timestamp,
  required String method,
  required String path,
  required String body,
}) {
  // COMENTÁRIO: A string a ser assinada é: timestamp + method + path + body
  final payload = utf8.encode('$timestamp$method$path$body');
  final key = utf8.encode(secret);
  final hmac = Hmac(sha256, key);
  final digest = hmac.convert(payload);
  return digest.toString();
}