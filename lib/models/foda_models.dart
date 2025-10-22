enum FodaArea {
  internal,    // Fortalezas y Debilidades (factores internos)
  external,    // Oportunidades y Amenazas (factores externos)
}

class FodaBlock {
  final String id;
  final String title;
  final List<String> content;
  final FodaArea area;

  const FodaBlock({
    required this.id,
    required this.title,
    required this.content,
    required this.area,
  });

  FodaBlock copyWith({
    String? id,
    String? title,
    List<String>? content,
    FodaArea? area,
  }) {
    return FodaBlock(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      area: area ?? this.area,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'area': area.toString(),
    };
  }

  factory FodaBlock.fromJson(Map<String, dynamic> json) {
    return FodaBlock(
      id: json['id'],
      title: json['title'],
      content: List<String>.from(json['content']),
      area: FodaArea.values.firstWhere(
        (e) => e.toString() == json['area'],
        orElse: () => FodaArea.internal,
      ),
    );
  }
}

class FodaAnalysis {
  final List<String> fortalezas;
  final List<String> oportunidades;
  final List<String> debilidades;
  final List<String> amenazas;

  const FodaAnalysis({
    required this.fortalezas,
    required this.oportunidades,
    required this.debilidades,
    required this.amenazas,
  });

  factory FodaAnalysis.empty() {
    return const FodaAnalysis(
      fortalezas: [],
      oportunidades: [],
      debilidades: [],
      amenazas: [],
    );
  }

  List<String> getContentById(String id) {
    switch (id) {
      case 'fortalezas':
        return fortalezas;
      case 'oportunidades':
        return oportunidades;
      case 'debilidades':
        return debilidades;
      case 'amenazas':
        return amenazas;
      default:
        return [];
    }
  }

  FodaAnalysis updateById(String id, List<String> content) {
    switch (id) {
      case 'fortalezas':
        return copyWith(fortalezas: content);
      case 'oportunidades':
        return copyWith(oportunidades: content);
      case 'debilidades':
        return copyWith(debilidades: content);
      case 'amenazas':
        return copyWith(amenazas: content);
      default:
        return this;
    }
  }

  FodaAnalysis copyWith({
    List<String>? fortalezas,
    List<String>? oportunidades,
    List<String>? debilidades,
    List<String>? amenazas,
  }) {
    return FodaAnalysis(
      fortalezas: fortalezas ?? this.fortalezas,
      oportunidades: oportunidades ?? this.oportunidades,
      debilidades: debilidades ?? this.debilidades,
      amenazas: amenazas ?? this.amenazas,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fortalezas': fortalezas,
      'oportunidades': oportunidades,
      'debilidades': debilidades,
      'amenazas': amenazas,
    };
  }

  factory FodaAnalysis.fromJson(Map<String, dynamic> json) {
    return FodaAnalysis(
      fortalezas: List<String>.from(json['fortalezas'] ?? []),
      oportunidades: List<String>.from(json['oportunidades'] ?? []),
      debilidades: List<String>.from(json['debilidades'] ?? []),
      amenazas: List<String>.from(json['amenazas'] ?? []),
    );
  }
}