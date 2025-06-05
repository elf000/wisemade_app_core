// lib/models/sub_member.dart

/// COMENTÁRIO: Modelo atualizado de SubMember para refletir
/// o schema real retornado pela API Foxbit (v3.0).
/// Nesta API, o sub-member é identificado pelo campo "sn".
class SubMember {
  final String sn;
  final String name;
  final String cpf;
  final String email;
  final String phone;

  SubMember({
    required this.sn,
    required this.name,
    required this.cpf,
    required this.email,
    required this.phone,
  });

  factory SubMember.fromJson(Map<String, dynamic> json) {
    // ───────────────────────────────────────────────────────────────────────
    // Checagens de segurança para evitar “No element”:
    //   - O campo "sn" identifica unicamente o sub-member.
    //   - O email vem diretamente do nível raiz.
    //   - O nome, cpf e telefone vêm de id_document.
    // ───────────────────────────────────────────────────────────────────────

    // 1) Verifica "sn"
    if (!json.containsKey('sn') || json['sn'] == null) {
      throw Exception('SubMember.fromJson: campo "sn" ausente em $json');
    }

    // 2) Verifica "email"
    if (!json.containsKey('email') || json['email'] == null) {
      throw Exception('SubMember.fromJson: campo "email" ausente em $json');
    }

    // 3) Verifica "id_document" como objeto
    if (!json.containsKey('id_document') || json['id_document'] == null) {
      throw Exception('SubMember.fromJson: campo "id_document" ausente em $json');
    }
    final idDoc = json['id_document'] as Map<String, dynamic>;

    // 4) Nome dentro de id_document.name
    if (!idDoc.containsKey('name') || idDoc['name'] == null) {
      throw Exception('SubMember.fromJson: campo "id_document.name" ausente em $idDoc');
    }

    // 5) CPF dentro de id_document.tax_id_number
    if (!idDoc.containsKey('tax_id_number') || idDoc['tax_id_number'] == null) {
      throw Exception('SubMember.fromJson: campo "id_document.tax_id_number" ausente em $idDoc');
    }

    // 6) Telefone dentro de id_document.phone_number
    if (!idDoc.containsKey('phone_number') || idDoc['phone_number'] == null) {
      throw Exception('SubMember.fromJson: campo "id_document.phone_number" ausente em $idDoc');
    }

    return SubMember(
      sn: json['sn'].toString(),
      name: idDoc['name'] as String,
      cpf: idDoc['tax_id_number'] as String,
      email: json['email'] as String,
      phone: idDoc['phone_number'] as String,
    );
  }
}