// import 'package:leadpallot/commons/styles/Spacing_style.dart';
// import 'package:leadpallot/features/authentification/screens/login/widgets/login_form.dart';
// import 'package:leadpallot/features/authentification/screens/login/widgets/login_header.dart';

// import 'package:leadpallot/utils/constants/sizes.dart';
// import 'package:leadpallot/utils/helpers/helpers_functions.dart';
// import 'package:flutter/material.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     bool dark = THelperFunctions.isDarkMode(context);
//     // final LoginController signupController = Get.put(
//     //   LoginController(),
//     // );

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: TSpacingStyle.paddingwithAppbarHeight * 1.3,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               // HEADING
//               // logo, title, subtitle
//               loginHeader(dark: dark),

//               // FORM
//               const loginForm(),

//               // Divider
//               // Tdivider(
//               //   dark: dark,
//               //   label: TTexts.orsigninwith,
//               // ),
//               SizedBox(height: Tsizes.spaceBtwSections),
//               // FOOTER
//               // loginSocialButtons(
//               //   ontapFacebookSignin: () =>
//               //   //    signupController.loginWithGoogleSignin(),
//               //   ontapGooglesignin: () =>
//               //    //   signupController.loginWithGoogleSignin(),
//               //   dark: dark,
//               // )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
