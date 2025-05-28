class Recognition {
  // ------------------------------- CONSTRUCTORS ------------------------------
  Recognition({
    this.detectedClass,
    this.confidenceInClass,
    this.rect,
    this.index,
    this.label,
    this.confidence,
    this.timestamp,
    this.date,
    this.score,
    this.keyPoints,
  });

  factory Recognition.fromJson(Map<Object?, Object?> json) => Recognition(
    detectedClass: json['detectedClass'] as String?,
    confidenceInClass: json['confidenceInClass'] as double?,
    rect: Rect.fromJson(json['rect'] as Map<Object?, Object?>?),
    index: json['index'] as int?,
    label: json['label'] as String?,
    confidence: json['confidence'] as double?,
    score: json['score'] as double?,
    keyPoints: json['keypoints'] != null
        ? (json['keypoints'] as Map<dynamic, Object?>?)!.values
              .map((e) => Keypoint.fromJson(e as Map<dynamic, Object?>?))
              .toList()
        : [],
  );

  // -------------------------------- FIELDS -----------------------------------
  double? confidenceInClass;
  String? detectedClass;
  Rect? rect;
  String? date;
  String? timestamp;
  int? index;
  String? label;
  double? confidence;

  ///PoseNet
  double? score;
  List<Keypoint>? keyPoints;

  // ------------------------------- METHODS -----------------------------------
  Map<dynamic, dynamic> toJson() => <String, dynamic>{
    'detectedClass': detectedClass,
    'confidenceInClass': confidenceInClass,
    'rect': rect?.toJson(),
    'index': index,
    'label': label,
    'confidence': confidence,
    'score': score,
    'keypoints': keyPoints,
  };

  @override
  String toString() {
    return 'Recognition{x: $confidenceInClass, '
        'detectedClass: $detectedClass, '
        'rect: $rect, '
        'index: $index, '
        'label: $label, '
        'confidence: $confidence}';
  }
}

class Rect {
  // ------------------------------- CONSTRUCTORS ------------------------------
  Rect({required this.x, required this.y, required this.w, required this.h});

  factory Rect.fromJson(Map<Object?, Object?>? json) => Rect(
    x: json != null ? json['x']! as double : 0.0,
    y: json != null ? json['y']! as double : 0.0,
    w: json != null ? json['w']! as double : 0.0,
    h: json != null ? json['h']! as double : 0.0,
  );

  // -------------------------------- FIELDS -----------------------------------
  double x = 0;
  double y = 0;
  double w = 0;
  double h = 0;

  // ------------------------------- METHODS -----------------------------------
  Map<dynamic, dynamic> toJson() => <String, dynamic>{
    'x': x,
    'y': y,
    'w': w,
    'h': h,
  };

  @override
  String toString() {
    return 'Rect{x: $x, y: $y, w: $w, h: $h}';
  }
}

class Keypoint {
  // ------------------------------- CONSTRUCTORS ------------------------------
  Keypoint({
    required this.x,
    required this.y,
    required this.score,
    required this.part,
  });

  factory Keypoint.fromJson(Map<dynamic, Object?>? json) => Keypoint(
    x: json != null ? json['x']! as double : 0.0,
    y: json != null ? json['y']! as double : 0.0,
    score: json != null ? json['score']! as double : 0.0,
    part: json != null ? json['part']! as String : '',
  );

  // -------------------------------- FIELDS -----------------------------------
  double x = 0;
  double y = 0;
  double score = 0;
  String part = '';

  // ------------------------------- METHODS -----------------------------------
  Map<dynamic, dynamic> toJson() => <String, dynamic>{
    'x': x,
    'y': y,
    'score': score,
    'part': part,
  };

  @override
  String toString() {
    return 'Rect{x: $x, y: $y, w: $score, h: $part}';
  }
}
