//import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../exeptions/exeptions.dart';
// import '../models/network_response.dart';
//
// class AuthRepository {
//   Future<NetworkResponse> loginWithEmailAndPassword({
//     required phoneNumber
//   }) async {
//     try {
//
//       FirebaseFirestore.instance.collection("users");
//       return NetworkResponse(data: userCredential);
//     } on Exception catch (e) {
//       return NetworkResponse(
//         errorText: e.toString(),
//       );
//     } catch (error) {
//       return NetworkResponse(
//           errorText: "An unknown exception occurred: $error");
//     }
//   }
//
//   Future<NetworkResponse> registerWithEmailAndPassword({
//     required String username,
//     required String number,
//   }) async {
//     try {
//       UserCredential userCredential =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: username,
//         password: password,
//       );
//
//       return NetworkResponse(data: userCredential);
//     } on FirebaseAuthException catch (e) {
//       return NetworkResponse(
//         errorText: SignUpWithEmailAndPasswordFailure.fromCode(e.code).message,
//         errorCode: e.code,
//       );
//     } catch (error) {
//       return NetworkResponse(
//           errorText: "An unknown exception occurred: $error");
//     }
//   }
//
//   Future<NetworkResponse> logOutUser() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       return NetworkResponse(data: "success");
//     } on FirebaseAuthException catch (e) {
//       return NetworkResponse(
//           errorText: "Sign Out Error: ${e.message}", errorCode: e.code);
//     } catch (_) {
//       return NetworkResponse(errorText: "An unknown exception occurred");
//     }
//   }
// }