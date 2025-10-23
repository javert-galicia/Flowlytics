enum CanvasArea {
  infrastructure,
  offer,
  customers,
  finance,
}

class GridArea {
  final int colSpan;
  final int rowSpan;

  const GridArea({
    required this.colSpan,
    required this.rowSpan,
  });
}

class CanvasBlock {
  final String id;
  final String title;
  final List<String> content;
  final CanvasArea area;
  final GridArea gridArea;

  const CanvasBlock({
    required this.id,
    required this.title,
    required this.content,
    required this.area,
    required this.gridArea,
  });

  CanvasBlock copyWith({
    String? id,
    String? title,
    List<String>? content,
    CanvasArea? area,
    GridArea? gridArea,
  }) {
    return CanvasBlock(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      area: area ?? this.area,
      gridArea: gridArea ?? this.gridArea,
    );
  }
}

class BusinessModelCanvas {
  final List<String> keyPartners;
  final List<String> keyActivities;
  final List<String> keyResources;
  final List<String> valuePropositions;
  final List<String> customerRelationships;
  final List<String> channels;
  final List<String> customerSegments;
  final List<String> costStructure;
  final List<String> revenueStreams;

  const BusinessModelCanvas({
    required this.keyPartners,
    required this.keyActivities,
    required this.keyResources,
    required this.valuePropositions,
    required this.customerRelationships,
    required this.channels,
    required this.customerSegments,
    required this.costStructure,
    required this.revenueStreams,
  });

  BusinessModelCanvas copyWith({
    List<String>? keyPartners,
    List<String>? keyActivities,
    List<String>? keyResources,
    List<String>? valuePropositions,
    List<String>? customerRelationships,
    List<String>? channels,
    List<String>? customerSegments,
    List<String>? costStructure,
    List<String>? revenueStreams,
  }) {
    return BusinessModelCanvas(
      keyPartners: keyPartners ?? this.keyPartners,
      keyActivities: keyActivities ?? this.keyActivities,
      keyResources: keyResources ?? this.keyResources,
      valuePropositions: valuePropositions ?? this.valuePropositions,
      customerRelationships: customerRelationships ?? this.customerRelationships,
      channels: channels ?? this.channels,
      customerSegments: customerSegments ?? this.customerSegments,
      costStructure: costStructure ?? this.costStructure,
      revenueStreams: revenueStreams ?? this.revenueStreams,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keyPartners': keyPartners,
      'keyActivities': keyActivities,
      'keyResources': keyResources,
      'valuePropositions': valuePropositions,
      'customerRelationships': customerRelationships,
      'channels': channels,
      'customerSegments': customerSegments,
      'costStructure': costStructure,
      'revenueStreams': revenueStreams,
    };
  }

  factory BusinessModelCanvas.fromJson(Map<String, dynamic> json) {
    return BusinessModelCanvas(
      keyPartners: List<String>.from(json['keyPartners'] ?? []),
      keyActivities: List<String>.from(json['keyActivities'] ?? []),
      keyResources: List<String>.from(json['keyResources'] ?? []),
      valuePropositions: List<String>.from(json['valuePropositions'] ?? []),
      customerRelationships: List<String>.from(json['customerRelationships'] ?? []),
      channels: List<String>.from(json['channels'] ?? []),
      customerSegments: List<String>.from(json['customerSegments'] ?? []),
      costStructure: List<String>.from(json['costStructure'] ?? []),
      revenueStreams: List<String>.from(json['revenueStreams'] ?? []),
    );
  }

  static BusinessModelCanvas empty() {
    return const BusinessModelCanvas(
      keyPartners: [],
      keyActivities: [],
      keyResources: [],
      valuePropositions: [],
      customerRelationships: [],
      channels: [],
      customerSegments: [],
      costStructure: [],
      revenueStreams: [],
    );
  }

  List<String> getContentById(String id) {
    switch (id) {
      case 'keyPartners':
        return keyPartners;
      case 'keyActivities':
        return keyActivities;
      case 'keyResources':
        return keyResources;
      case 'valuePropositions':
        return valuePropositions;
      case 'customerRelationships':
        return customerRelationships;
      case 'channels':
        return channels;
      case 'customerSegments':
        return customerSegments;
      case 'costStructure':
        return costStructure;
      case 'revenueStreams':
        return revenueStreams;
      default:
        return [];
    }
  }

  BusinessModelCanvas updateById(String id, List<String> content) {
    switch (id) {
      case 'keyPartners':
        return copyWith(keyPartners: content);
      case 'keyActivities':
        return copyWith(keyActivities: content);
      case 'keyResources':
        return copyWith(keyResources: content);
      case 'valuePropositions':
        return copyWith(valuePropositions: content);
      case 'customerRelationships':
        return copyWith(customerRelationships: content);
      case 'channels':
        return copyWith(channels: content);
      case 'customerSegments':
        return copyWith(customerSegments: content);
      case 'costStructure':
        return copyWith(costStructure: content);
      case 'revenueStreams':
        return copyWith(revenueStreams: content);
      default:
        return this;
    }
  }
}

// Team Canvas Model
class TeamCanvas {
  final List<String> people;
  final List<String> activities;
  final List<String> personalGoals;
  final List<String> purpose;
  final List<String> rules;
  final List<String> skills;
  final List<String> tools;
  final List<String> network;
  final List<String> values;

  const TeamCanvas({
    required this.people,
    required this.activities,
    required this.personalGoals,
    required this.purpose,
    required this.rules,
    required this.skills,
    required this.tools,
    required this.network,
    required this.values,
  });

  TeamCanvas copyWith({
    List<String>? people,
    List<String>? activities,
    List<String>? personalGoals,
    List<String>? purpose,
    List<String>? rules,
    List<String>? skills,
    List<String>? tools,
    List<String>? network,
    List<String>? values,
  }) {
    return TeamCanvas(
      people: people ?? this.people,
      activities: activities ?? this.activities,
      personalGoals: personalGoals ?? this.personalGoals,
      purpose: purpose ?? this.purpose,
      rules: rules ?? this.rules,
      skills: skills ?? this.skills,
      tools: tools ?? this.tools,
      network: network ?? this.network,
      values: values ?? this.values,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'people': people,
      'activities': activities,
      'personalGoals': personalGoals,
      'purpose': purpose,
      'rules': rules,
      'skills': skills,
      'tools': tools,
      'network': network,
      'values': values,
    };
  }

  factory TeamCanvas.fromJson(Map<String, dynamic> json) {
    return TeamCanvas(
      people: List<String>.from(json['people'] ?? []),
      activities: List<String>.from(json['activities'] ?? []),
      personalGoals: List<String>.from(json['personalGoals'] ?? []),
      purpose: List<String>.from(json['purpose'] ?? []),
      rules: List<String>.from(json['rules'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      tools: List<String>.from(json['tools'] ?? []),
      network: List<String>.from(json['network'] ?? []),
      values: List<String>.from(json['values'] ?? []),
    );
  }

  static TeamCanvas empty() {
    return const TeamCanvas(
      people: [],
      activities: [],
      personalGoals: [],
      purpose: [],
      rules: [],
      skills: [],
      tools: [],
      network: [],
      values: [],
    );
  }

  List<String> getContentById(String id) {
    switch (id) {
      case 'people':
        return people;
      case 'activities':
        return activities;
      case 'personalGoals':
        return personalGoals;
      case 'purpose':
        return purpose;
      case 'rules':
        return rules;
      case 'skills':
        return skills;
      case 'tools':
        return tools;
      case 'network':
        return network;
      case 'values':
        return values;
      default:
        return [];
    }
  }

  TeamCanvas updateById(String id, List<String> content) {
    switch (id) {
      case 'people':
        return copyWith(people: content);
      case 'activities':
        return copyWith(activities: content);
      case 'personalGoals':
        return copyWith(personalGoals: content);
      case 'purpose':
        return copyWith(purpose: content);
      case 'rules':
        return copyWith(rules: content);
      case 'skills':
        return copyWith(skills: content);
      case 'tools':
        return copyWith(tools: content);
      case 'network':
        return copyWith(network: content);
      case 'values':
        return copyWith(values: content);
      default:
        return this;
    }
  }
}