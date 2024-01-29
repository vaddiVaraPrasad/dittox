class Shop {
  late String id;
  late String name;
  late String address;
  late double locationX;
  late double locationY;
  late String storeName;
  late String costOneSide;
  late String costTwoSide;
  late String costBlack;
  late String costColor;
  late String sizeA4;
  late String legal;
  late String letter;
  late String sizeB5;
  late String sizeA6;
  late String postCard;
  late String size5X7;
  late String size4X6;
  late String size35X5;
  late String sizeA5;
  late String spiralBinding;
  late String staplesBinding;
  late String stickFile;
  late String quality100Gsm;
  late String quality80gsm;
  late String bondPage;
  late String email;
  late String contactNumber;
  late String openingTime;
  late String closingTime;
  late List<dynamic> feedback;
  late List<dynamic> reviewer;
  late int avgRating;
  late double cost;
  late String distance;
  late String duration;

  Shop.fromJson(Map<String, dynamic> json, double _cost, String _distance,
      String _address, String _duration) {
    id = json['_id'];
    name = json['name'];
    address = _address;
    locationX = json['location']['x'];
    locationY = json['location']['y'];
    storeName = json['meta']['storeName'];
    costOneSide = json['meta']['costOneSide'];
    costTwoSide = json['meta']['costTwoSide'];
    costBlack = json['meta']['costBlack'];
    costColor = json['meta']['costColor'];
    sizeA4 = json['meta']['sizeA4'];
    legal = json['meta']['legal'];
    letter = json['meta']['letter'];
    sizeB5 = json['meta']['sizeB5'];
    sizeA6 = json['meta']['sizeA6'];
    postCard = json['meta']['postCard'];
    size5X7 = json['meta']['size5X7'];
    size4X6 = json['meta']['size4X6'];
    size35X5 = json['meta']['size35X5'];
    sizeA5 = json['meta']['sizeA5'];
    spiralBinding = json['meta']['spiralBinding'];
    staplesBinding = json['meta']['staplesBinding'];
    stickFile = json['meta']['stickFile'];
    quality100Gsm = json['meta']['quality100Gsm'];
    quality80gsm = json['meta']['quality80gsm'];
    bondPage = json['meta']['bondPage'];
    email = json['meta']['email'];
    contactNumber = json['meta']['contactNumber'];
    openingTime = json['meta']['openingTime'];
    closingTime = json['meta']['closingTime'];
    feedback = json['feedBack'];
    reviewer = json['reviewer'];
    avgRating = json['avgRating'];
    cost = _cost;
    distance = _distance;
    duration = _duration;
  }

  Map<String, dynamic> get toMap {
    return {
      'id': id,
      'name': name,
      'address': address,
      'locationX': locationX,
      'locationY': locationY,
      'storeName': storeName,
      'costOneSide': costOneSide,
      'costTwoSide': costTwoSide,
      'costBlack': costBlack,
      'costColor': costColor,
      'sizeA4': sizeA4,
      'legal': legal,
      'letter': letter,
      'sizeB5': sizeB5,
      'sizeA6': sizeA6,
      'postCard': postCard,
      'size5X7': size5X7,
      'size4X6': size4X6,
      'size35X5': size35X5,
      'sizeA5': sizeA5,
      'spiralBinding': spiralBinding,
      'staplesBinding': staplesBinding,
      'stickFile': stickFile,
      'quality100Gsm': quality100Gsm,
      'quality80gsm': quality80gsm,
      'bondPage': bondPage,
      'email': email,
      'contactNumber': contactNumber,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'feedback': feedback,
      'reviewer': reviewer,
      'avgRating': avgRating,
      'cost': cost,
      'distance': distance,
      'duration': duration,
    };
  }
}
