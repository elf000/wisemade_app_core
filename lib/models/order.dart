// lib/models/order.dart

/// Modelo genérico para resposta de criação de ordem.
class OrderResponse {
  final String orderId;
  final String status;
  final String? pixPayload;    // Para compra (PIX)
  final String? pixKey;        // Para compra (chave Pix)
  final String? walletAddress; // Para venda (endereço de carteira)

  OrderResponse({
    required this.orderId,
    required this.status,
    this.pixPayload,
    this.pixKey,
    this.walletAddress,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') || json['id'] == null) {
      throw Exception('OrderResponse.fromJson: campo "id" ausente em $json');
    }
    if (!json.containsKey('status') || json['status'] == null) {
      throw Exception('OrderResponse.fromJson: campo "status" ausente em $json');
    }

    String? pixPayload;
    String? pixKey;
    if (json.containsKey('payment') && json['payment'] != null) {
      final pay = json['payment'] as Map<String, dynamic>;
      pixPayload = pay['payload']?.toString();
      pixKey     = pay['key']?.toString();
    }

    final walletAddress = json['crypto_address']?.toString();

    return OrderResponse(
      orderId:        json['id'].toString(),
      status:         json['status'] as String,
      pixPayload:     pixPayload,
      pixKey:         pixKey,
      walletAddress:  walletAddress,
    );
  }
}