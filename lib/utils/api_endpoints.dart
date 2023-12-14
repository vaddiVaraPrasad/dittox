import "package:flutter/material.dart";

class ApiEndPoiunts {
  static const Login_endpoint = "https://dittox.in/xerox/v1/account/login";

  //   endpoint: https://dittox.in/xerox/v1/account/login

  // payload: {
  //   email:string,
  // password: string
  // }

  // If user exist true →

  // {
  //     "responseCode": "OK",
  //     "message": "User logged in successfully.",
  //     "result": {
  //         "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7Il9pZCI6IjY1NGIzOGYwNmZiZDUzZThhZTg5NTQ5MiIsImVtYWlsIjoidmFyYXByYXNhZHZhZGRpMDRAZ21haWwuY29tIiwibmFtZSI6InZhcmFwcmFzYWQifSwiaWF0IjoxNzAyNDg2MjEyLCJleHAiOjE3MDI1NzI2MTJ9.ZwvREkEuEKRlzeoqNtwoMQFNlC0K-kdy-3JwNAUrxwg",
  //         "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7Il9pZCI6IjY1NGIzOGYwNmZiZDUzZThhZTg5NTQ5MiIsImVtYWlsIjoidmFyYXByYXNhZHZhZGRpMDRAZ21haWwuY29tIiwibmFtZSI6InZhcmFwcmFzYWQifSwiaWF0IjoxNzAyNDg2MjEyLCJleHAiOjE3MTgyOTc0MTJ9.BMabWWE9_hJBJNSIJ9ulxoJrU1V2VU-XZbPNHDY-Gvk",
  //         "user": {
  //             "_id": "654b38f06fbd53e8ae895492",
  //             "mobile": "9133931892",
  //             "email": {
  //                 "address": "varaprasadvaddi04@gmail.com",
  //                 "verified": true
  //             },
  //             "name": "varaprasad",
  //             "deleted": false,
  //             "designation": [],
  //             "location": [],
  //             "updatedAt": "2023-11-08T07:29:52.242Z",
  //             "createdAt": "2023-11-08T07:29:52.242Z",
  //             "lastLoggedInAt": "2023-11-09T14:17:56.050Z"
  //         }
  //     },
  //     "meta": {
  //         "correlation": "4c7d7e70-836d-4fad-8703-e90b32a5f95d"
  //     }
  // }

  // Password is wrong
  // {
  //     "responseCode": "CLIENT_ERROR",
  //     "message": "Username or password is invalid.",
  //     "error": [],
  //     "meta": {
  //         "correlation": "f7028309-a441-4393-aa7e-c61d573bf4ba"
  //     }
  // }

  // Mail is wrong
  // {
  //     "responseCode": "CLIENT_ERROR",
  //     "message": "Please enter the correct login ID and Password.",
  //     "error": [],
  //     "meta": {
  //         "correlation": "bb6713c6-4d9b-4876-b881-b549ef5cbb46"
  //     }
  // }
}
