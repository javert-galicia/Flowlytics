enum ValuePropositionArea {
  customerProfile,    // Perfil del cliente (lado derecho)
  valueMap,          // Mapa de valor (lado izquierdo)
}

class ValuePropositionBlock {
  final String id;
  final String title;
  final List<String> content;
  final ValuePropositionArea area;

  const ValuePropositionBlock({
    required this.id,
    required this.title,
    required this.content,
    required this.area,
  });

  ValuePropositionBlock copyWith({
    String? id,
    String? title,
    List<String>? content,
    ValuePropositionArea? area,
  }) {
    return ValuePropositionBlock(
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

  factory ValuePropositionBlock.fromJson(Map<String, dynamic> json) {
    return ValuePropositionBlock(
      id: json['id'],
      title: json['title'],
      content: List<String>.from(json['content']),
      area: ValuePropositionArea.values.firstWhere(
        (e) => e.toString() == json['area'],
        orElse: () => ValuePropositionArea.customerProfile,
      ),
    );
  }
}

class ValuePropositionCanvas {
  // Customer Profile (lado derecho)
  final List<String> customerJobs; // Trabajos del cliente
  final List<String> pains; // Frustraciones
  final List<String> gains; // Alegrías

  // Value Map (lado izquierdo)  
  final List<String> products; // Productos y servicios
  final List<String> painRelievers; // Aliviadores de frustraciones
  final List<String> gainCreators; // Creadores de alegrías

  const ValuePropositionCanvas({
    required this.customerJobs,
    required this.pains,
    required this.gains,
    required this.products,
    required this.painRelievers,
    required this.gainCreators,
  });

  factory ValuePropositionCanvas.empty() {
    return const ValuePropositionCanvas(
      customerJobs: [],
      pains: [],
      gains: [],
      products: [],
      painRelievers: [],
      gainCreators: [],
    );
  }

  List<String> getContentById(String id) {
    switch (id) {
      case 'customerJobs':
        return customerJobs;
      case 'pains':
        return pains;
      case 'gains':
        return gains;
      case 'products':
        return products;
      case 'painRelievers':
        return painRelievers;
      case 'gainCreators':
        return gainCreators;
      default:
        return [];
    }
  }

  ValuePropositionCanvas updateById(String id, List<String> content) {
    switch (id) {
      case 'customerJobs':
        return copyWith(customerJobs: content);
      case 'pains':
        return copyWith(pains: content);
      case 'gains':
        return copyWith(gains: content);
      case 'products':
        return copyWith(products: content);
      case 'painRelievers':
        return copyWith(painRelievers: content);
      case 'gainCreators':
        return copyWith(gainCreators: content);
      default:
        return this;
    }
  }

  ValuePropositionCanvas copyWith({
    List<String>? customerJobs,
    List<String>? pains,
    List<String>? gains,
    List<String>? products,
    List<String>? painRelievers,
    List<String>? gainCreators,
  }) {
    return ValuePropositionCanvas(
      customerJobs: customerJobs ?? this.customerJobs,
      pains: pains ?? this.pains,
      gains: gains ?? this.gains,
      products: products ?? this.products,
      painRelievers: painRelievers ?? this.painRelievers,
      gainCreators: gainCreators ?? this.gainCreators,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerJobs': customerJobs,
      'pains': pains,
      'gains': gains,
      'products': products,
      'painRelievers': painRelievers,
      'gainCreators': gainCreators,
    };
  }

  factory ValuePropositionCanvas.fromJson(Map<String, dynamic> json) {
    return ValuePropositionCanvas(
      customerJobs: List<String>.from(json['customerJobs'] ?? []),
      pains: List<String>.from(json['pains'] ?? []),
      gains: List<String>.from(json['gains'] ?? []),
      products: List<String>.from(json['products'] ?? []),
      painRelievers: List<String>.from(json['painRelievers'] ?? []),
      gainCreators: List<String>.from(json['gainCreators'] ?? []),
    );
  }
}