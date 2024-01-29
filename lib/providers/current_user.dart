// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../helpers/sqlLite.dart';
import '../helpers/user_location.dart';
import "../model/user.dart";

class CurrentUser with ChangeNotifier {
  late Users current_user = Users(
    userId: "Loading...",
    userName: "Loading...",
    userEmail: "Loading...",
    userPlaceName: "Bangalore",
    latitude: 12.972442,
    longitude: 77.580643,
    userPhoneNumber: "",
    userContryName: "India",
    userAccessToken: "",
  );

  void initCurrentUser(String id, String userNewAccessToken, double locationX,
      double locationY) async {
    Map<String, dynamic> user_map = await SQLHelpers.getUserById(id);
    Users tempuser = Users(
      userId: user_map["userId"],
      userName: user_map["userName"],
      userEmail: user_map["userEmail"],
      userPlaceName: user_map["userPlaceName"],
      latitude: locationX,
      longitude: locationY,
      userPhoneNumber: user_map["userPhoneNumber"],
      userContryName: user_map["userContryName"],
      userAccessToken: userNewAccessToken,
    );

    var updateUserAccessTokenResponce =
        await SQLHelpers.updateUserAccessToken(id, userNewAccessToken);
    print(updateUserAccessTokenResponce);

    current_user = tempuser;
    print("init current user is called");
    print("user is updated");
    print(getCurrentUserMap);
    notifyListeners();
  }

  String get getUserAccessToken {
    return current_user.userAccessToken;
  }

  String get getUserId {
    return current_user.userId;
  }

  void setCurrentUser(Users curUser) {
    current_user = curUser;
    SQLHelpers.insertUser(current_user);
    notifyListeners();
  }

  void loadLatestUser() async {
    Map<String, dynamic> latestUser = await SQLHelpers.getLatestUser("users");
    if (latestUser != {}) {
      Users latCurUser = Users(
        userId: latestUser["userId"],
        userName: latestUser["userName"],
        userEmail: latestUser["userEmail"],
        userPlaceName: latestUser["userPlaceName"],
        latitude: latestUser["latitude"],
        longitude: latestUser["longitude"],
        userPhoneNumber: latestUser["userPhoneNumber"],
        userContryName: latestUser["userContryName"],
        userAccessToken: latestUser["userAccessToken"],
      );
      current_user = latCurUser;
      print("old user is loaded");
      notifyListeners();
    }
  }

  void loadUserByAccessToken(String accessToken) async {
    Map<String, dynamic> idUserMap =
        await SQLHelpers.getUserByAccessToken(accessToken);
    print("in provider");
    print(idUserMap);
    if (idUserMap.isEmpty) {
      // need to add after gauvrav send this

      // print("need to load the user Data!!!!!");
      // final data =
      //     await FirebaseFirestore.instance.collection('Users').doc(id).get();
      // Position userCurrentPosition = await UserLocation.getUserLatLong();
      // Map<String, dynamic> userPlaceMark = await UserLocation.getUserPlaceMarks(
      //     userCurrentPosition.latitude, userCurrentPosition.longitude);
      // var user = data.data();
      // Users logInFireStoreUSer = Users(
      //   userId: user!["userId"],
      //   userName: user["userName"],
      //   userEmail: user["email"],
      //   userPlaceName: userPlaceMark["locality"],
      //   latitude: userCurrentPosition.latitude,
      //   longitude: userCurrentPosition.longitude,
      //   userContryName: userPlaceMark["country"],
      // );
      // current_user = logInFireStoreUSer;
      // await SQLHelpers.insertUser(current_user);
      // print("USER FROM FIREBASE IS USED");
      notifyListeners();
    } else {
      Position userCurrentPosition = await UserLocation.getUserLatLong();
      Map<String, dynamic> userPlaceMark = await UserLocation.getUserPlaceMarks(
          userCurrentPosition.latitude, userCurrentPosition.longitude);

      Users id_user = Users(
          userId: idUserMap["userId"],
          userName: idUserMap["userName"],
          userEmail: idUserMap["userEmail"],
          userPlaceName: userPlaceMark["locality"],
          latitude: userCurrentPosition.latitude,
          longitude: userCurrentPosition.longitude,
          userContryName: userPlaceMark["country"],
          userPhoneNumber: idUserMap["userPhoneNumber"],
          userAccessToken: idUserMap["userAccessToken"]);
      current_user = id_user;
      print("old user is loaded");
      notifyListeners();
    }
  }

  Users get gerUser {
    return current_user;
  }

  void setUserName(String userName) {
    current_user.userName = userName;
    SQLHelpers.insertUser(current_user);
    notifyListeners();
  }

  String get getUserName {
    return current_user.userName;
  }

  void setUserEmail(String userEmail) {
    current_user.userEmail = userEmail;
    SQLHelpers.insertUser(current_user);
    notifyListeners();
  }

  String get getUserEmail {
    return current_user.userEmail;
  }

  void setUserPlaceName(String userPlaceName) {
    current_user.userPlaceName = userPlaceName;
    SQLHelpers.insertUser(current_user);
    notifyListeners();
  }

  String get getPlaceName {
    return current_user.userPlaceName;
  }

  void setUserLatitudeLogitude(double latitude, double logitude) {
    current_user.latitude = latitude;
    current_user.longitude = logitude;
    notifyListeners();
  }

  double get getUsetLatitude {
    return current_user.latitude;
  }

  double get getUserLongitude {
    return current_user.longitude;
  }

  void setUserPhoneNumber(String userPhoneNumber) {
    current_user.userPhoneNumber = userPhoneNumber;
    SQLHelpers.insertUser(current_user);
    notifyListeners();
  }

  String get getUserPhoneNumber {
    return current_user.userPhoneNumber;
  }

  void setUserContryName(String countryName) {
    current_user.userContryName = countryName;
    SQLHelpers.insertUser(current_user);
    notifyListeners();
  }

  String get getUserContryName {
    return current_user.userContryName;
  }

  Map<String, dynamic> get getCurrentUserMap {
    return current_user.toMap;
  }
}
