// import 'package:bloc/bloc.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
//
// import '../../../utility/database/local/cach_data.dart';
// import '../../../utility/database/local/cache_helper.dart';
//
// class SignUpCubit extends Cubit<SignUpStates>
// {
//   SignUpCubit(this.signUpRepo):super(SignUpInitialState());
//   SignUpRepo signUpRepo;
//   static SignUpCubit get(context)=>BlocProvider.of<SignUpCubit>(context);
//   var emailController=TextEditingController();
//   var passwordController=TextEditingController();
//   var nameController=TextEditingController();
//   var phoneController=TextEditingController();
//   var rePasswordController=TextEditingController();
//   var addressController=TextEditingController();
//   var nationalId=TextEditingController();
//   var codeController=TextEditingController();
//   var priceController=TextEditingController();
//
//   var formKey = GlobalKey<FormState>();
//   String? type;
//   String? technicalTypeSelected;
//   int? technicalTypeSelectedId;
//
//   String? technicalExperienceYears;
//   final List<String> years=[];
//   dynamic item;
//
//
//
//
//   bool visibility = true;
//   bool visibilityRePassword = true;
//
//   void changeVisibilityPassword() {
//     visibility = !visibility;
//     emit(ChangeVisibilityPasswordSignUp());
//   }
//   void changeVisibilityRePassword() {
//     visibilityRePassword = !visibilityRePassword;
//     emit(ChangeVisibilityRePasswordSignUp());
//   }
//
//
//   void selectAddress(String address) {
//     addressController.text = address;
//     emit(SelectAddressState());
//   }
//
//
//   Future<void> signUp({required type})async{
//     emit(SignUpLoadingState());
//     var data=await signUpRepo.signUp(
//        nameController.text,
//       emailController.text,
//       phoneController.text,
//       passwordController.text,
//        rePasswordController.text,
//        addressController.text,
//        type!,
//
//     );
//     data.fold(
//           (l) {
//             print(l);
//         emit(
//             SignUpErrorState(l.message));
//       },
//           (r) {
//             emit(SignUpSuccessState(r));
//             sendCode();
//           },
//     );
//   }
//
//
//   Future<void> signUpTechnical({required type})async{
//     emit(SignTechnicalUpLoadingState());
//     var data=await signUpRepo.signUpTechnical(
//       nameController.text,
//       emailController.text,
//       phoneController.text,
//       passwordController.text,
//       rePasswordController.text,
//       addressController.text,
//       type!,
//       technicalTypeSelectedId.toString()!,
//       nationalId.text,
//       technicalExperienceYears!,
//         priceController.text,
//     );
//     data.fold(
//           (l) {
//         print(l);
//         emit(
//             SignUpTechnicalErrorState(l.message));
//       },
//           (r) {
//         emit(SignUpTechnicalSuccessState(r));
//         sendCode();
//           },
//     );
//   }
//
//
//
//
//   Future<void> sendCode()async{
//     emit(SendCodeLoadingState());
//     var data=await signUpRepo.sendCode(email: emailController.text);
//     data.fold(
//           (l) {
//         print(l);
//         emit(
//             SendCodeErrorState(l.message));
//       },
//           (r) {
//         emit(SendCodeSuccessState(r));
//       },
//     );
//   }
//
//
//   Future<void> verifyEmail()async{
//     emit(VerifyEmailLoadingState());
//     var data=await signUpRepo.verifyEmail(code: codeController.text,email: emailController.text);
//     data.fold(
//           (l) {
//         print(l);
//         emit(
//             VerifyEmailErrorState(l.message));
//       },
//           (r) {
//         emit(VerifyEmailSuccessState(r));
//       },
//     );
//   }
//
//
// }