import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rally/configs/fcm_config.dart';
import 'package:rally/main.dart';
import 'package:rally/util/logging.dart';

class AuthRepository {
  String deviceUrl = '127.0.0.1:8080';
  String advUrl = 'http://10.0.0.2:8080';
  String temporaryUrl = 'http://192.168.0.9.8080';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email'], serverClientId: 'rally-app-99aa7@appspot.gserviceaccount.com');

  GoogleSignIn get currentAccount => _googleSignIn;

  final BaseOptions _options = BaseOptions(
    baseUrl: 'http://10.0.2.2:8080',
    headers: {'content-Type': 'application/json'},
    responseType: ResponseType.json,
    connectTimeout: const Duration(milliseconds: 5000),
    receiveTimeout: const Duration(milliseconds: 10000),
    sendTimeout: const Duration(milliseconds: 5000),
  );

  Future<void> googleSignIn() async {
    final dio = Dio(_options);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication authentication = await googleUser.authentication;

      String deviceToken = await getToken();
      // !-- Initialize user data in the Keystore/Keychain. --!
      await keyInit();

      // !-- A new ID_TOKEN is issued and stored in Keystore/Keychain. --!
      await storage.write(key: 'ID_TOKEN', value: authentication.idToken);

      // !-- Configure the interceptor for sign in. --!
      // !-- It also includes the processing of users who have not registered as members. --!
      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onError: (error, handler) async {
            // !-- Handling users not registered in the DB. --!
            if (error.response?.statusCode == 404) {
              await signUpWithGoogle(
                  authentication: authentication,
                  dispName: googleUser.email.split('@')[0],
                  idToken: authentication.idToken,
                  deviceToken: deviceToken);

              return handler.resolve(await dio.fetch(error.requestOptions));
            }

            // if (error.type == DioExceptionType.connectionTimeout) {
            //   timeOutDialog(navigatorKey.currentContext!);
            // }

            if (error.response?.statusCode == 401) {
              print(error);
              return;
            }
            return handler.next(error);
          },
        ),
      );

      dio.options.headers['Identifier'] = 'Bearer ${authentication.idToken}';

      Response response = await dio.post('/auth/google-sign-in', data: {'deviceToken': deviceToken});

      if (response.statusCode == 200) {
        printLog(message: '[RESPONSE](${response.statusCode}) : ${response.data}');
        await storage.write(key: 'USER_ID', value: response.data['userId'].toString());
        await storage.write(key: 'ACCESS_TOKEN', value: response.headers.value('authorization')!.substring(7));
        await _auth.signInWithCredential(GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken,
        ));

        return;
      }
    } catch (e) {
      printError(error: '$e');
    }
  }

  Future<void> signUpWithGoogle(
      {required GoogleSignInAuthentication authentication,
        required String? dispName,
        required String? idToken,
        required String deviceToken}) async {
    final dio = Dio(_options);
    dio.options.headers['identifier'] = 'Bearer $idToken';

    UserCredential user = await _auth.signInWithCredential(GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    ));

    Response response = await dio
        .post('/auth/google-sign-up', data: {'display_name': dispName, 'uuid': user.user!.uid, 'device_token': deviceToken});

    if (response.statusCode != 200) {
      return;
    }

    printLog(message: '[RESPONSE](${response.statusCode}) : ${response.data}');
    await storage.write(key: 'USER_ID', value: response.data['userId'].toString());
    return;
  }

  Dio customDioObject() {
    Dio dio = Dio(_options);

    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? accessToken = await storage.read(key: 'ACCESS_TOKEN');
          options.headers['Authorization'] = 'Bearer $accessToken';

          return handler.next(options);
        },
        onError: (error, handler) async {
          // !-- Access token expired --!
          if (error.response?.statusCode == 401) {
            print('[WETO APPLICATION SERVER] : Your ACCESS_TOKEN has expired.');

            await storage.delete(key: 'ACCESS_TOKEN');
            await storage.delete(key: 'ID_TOKEN');

            await reAuthenticate();
            await reissueAccessToken();

            String? reissuedAccessToken = await storage.read(key: 'ACCESS_TOKEN');

            error.requestOptions.headers['Authorization'] = 'Bearer $reissuedAccessToken';

            return handler.resolve(await dio.fetch(error.requestOptions));
          } else {
            FocusScope.of(navigatorKey.currentContext!).unfocus();
            printError(error: '${error.response?.data}');
            return showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) => AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                title: Text('ERROR :: ${error.response?.statusCode}'),
                content: Text('${error.response?.data}'),
              ),
            );
          }
        },
      ),
    );

    return dio;
  }

  Future<void> googleSignOut() async {
    await keyInit();
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> reAuthenticate() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently(reAuthenticate: true);

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication authentication = await googleUser.authentication;
      await storage.delete(key: 'ID_TOKEN');
      await storage.write(key: 'ID_TOKEN', value: authentication.idToken);

      print('[GOOGLE OAUTH 2.0] : Re-authentication was successful. A new ID_TOKEN has been issued.');
      return;
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == GoogleSignIn.kSignInRequiredError) {
          // TODO :: re sign in
          print(e);
        } else if (e.code == GoogleSignIn.kSignInFailedError) {
          // TODO ::
          print(e);
        } else if (e.code == GoogleSignIn.kNetworkError) {
          // TODO ::
          print(e);
        } else if (e.code == GoogleSignIn.kSignInCanceledError) {
          // TODO ::
          print(e);
        }
      }
    }
  }

  Future<void> reissueAccessToken() async {
    String? userId = await storage.read(key: 'USER_ID');
    String? idToken = await storage.read(key: 'ID_TOKEN');

    if (userId == null || idToken == null) {
      return;
    }

    final refreshDio = Dio(_options);

    refreshDio.interceptors.clear();
    refreshDio.interceptors.add(
      InterceptorsWrapper(
        // !-- Id token expired --!
        onError: (error, handler) async {
          FocusScope.of(navigatorKey.currentContext!).unfocus();
          printError(error: error);
          return showDialog(
            context: navigatorKey.currentContext!,
            builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              title: Text('ERROR :: ${error.response?.statusCode}'),
              content: Text('${error.response?.data}'),
            ),
          );
        },
      ),
    );

    refreshDio.options.headers['Identifier'] = 'Bearer $idToken';

    Response refreshResponse = await refreshDio.post('/auth/reissue', data: {'userId': int.parse(userId)});

    final newAccessToken = refreshResponse.headers.value('authorization')!.substring(7);
    await storage.delete(key: 'ACCESS_TOKEN');
    await storage.write(key: 'ACCESS_TOKEN', value: newAccessToken);
    print('[WETO APPLICATION SERVER] : A new ACCESS TOKEN has been issued.');
  }

  Future<void> keyInit() async {
    await storage.delete(key: 'USER_ID');
    await storage.delete(key: 'ACCESS_TOKEN');
    await storage.delete(key: 'ID_TOKEN');
  }

  progressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16.0),
              Text("로그인 중..."),
            ],
          ),
        );
      },
    );
  }

  timeOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('시간 초과.'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('서버와의 통신이 원활하지 않습니다'),
              Text('잠시 후 다시 시도해주십시오.'),
            ],
          ),
        );
      },
    );
  }

  errorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please log in to continue.'),
          actions: [
            TextButton(
              onPressed: () {
                googleSignIn();
                Navigator.pop(context);
              },
              child: const Text('Sign In'),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  errorSnackBar(BuildContext context, DioException error) {
    const snackBar = SnackBar(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
      behavior: SnackBarBehavior.floating,
      content: Text(
        'Application server error.',
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

// Future<bool> signUp(String username, String password, String? dispName) async {
//   final dio = Dio(_options);
//   String deviceToken = await getToken();
//   String colorCode = getRandomColor();
//
//   SignUpModel model =
//   SignUpModel(username: username, password: password, deviceToken: deviceToken, colorCode: colorCode, dispName: dispName);
//
//   Response response = await dio.post('/auth/sign-up', data: model.toMap());
//
//   if (response.statusCode != 200) {
//     return false;
//   }
//   return true;
// }
//

// //  After comparing the data with the server using the member ID and password,
// //  the Authorization token in response is stored in the Shared Preference.
// // Returns an error if the login request fails.
// // ex) username or password mismatch, connection error with the server, etc.
// // If the auth token is in a Secure storage, the global state should be changed by the stream.

// Future<void> signIn(String username, String password) async {
//   final dio = Dio(_options);
//   AuthUserModel user = AuthUserModel(username: username, password: password);
//
//   Response response = await dio.post('/auth/sign-in', data: user.toMap());
//
//   // < !-- Connection Error --! >
//   if (response.statusCode == 500) {
//     return;
//   }
//
//   // < !-- Authentication Error --! >
//   if (response.statusCode == 401) {
//     if (response.data['error'] == 'Invalid password') {
//       print(response.data);
//     }
//
//     if (response.data['error'] == 'Invalid username') {
//       print(response.data);
//     }
//     return;
//   }
//
//   if (response.statusCode == 200) {
//     await storage.write(key: 'USER', value: user.toString());
//     await storage.write(key: 'ACCESS_TOKEN', value: response.data['AccessToken']);
//     await storage.write(key: 'REFRESH_TOKEN', value: response.data['RefreshToken']);
//
//     return;
//   }
// }
// TODO :: Need to prompt the client to sign in.
// showDialog(
// context: context,
// builder: (BuildContext context) {
// return AlertDialog(
// title: const Text('Login Required'),
// content: const Text('Please log in to continue.'),
// actions: [
// TextButton(
// onPressed: () {
// googleSignIn();
// Navigator.pop(context);
// },
// child: const Text('Sign In'),
// ),
// TextButton(
// child: const Text('OK'),
// onPressed: () {
// Navigator.pop(context);
// },
// ),
// ],
// );
// },
// );
// return;
