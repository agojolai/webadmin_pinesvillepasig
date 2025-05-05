import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webadmin_pinesville/common/styles/spacing_styles.dart';
import 'package:webadmin_pinesville/utils/constants/sizes.dart';

class LoginScreenDesktopTablet extends StatefulWidget {
  const LoginScreenDesktopTablet({super.key});

  @override
  State<LoginScreenDesktopTablet> createState() => LoginScreenDesktopTabletState();
}

class LoginScreenDesktopTabletState extends State<LoginScreenDesktopTablet> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // important when using background image
      body: Stack(
        children: [
          // Background image with repeating effect
          Positioned.fill(
              child: Opacity(
                opacity: 0.2, // Adjust opacity (0.0 to 1.0, where 0.0 is fully transparent)
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image_assets/Login - Background (multiply).png'), // Your background image
                      fit: BoxFit.none, // Use 'none' to prevent stretching
                      repeat: ImageRepeat.repeat, // Makes the image repeat
                    ),
                  ),
                ),)

          ),

          // Foreground content (login form and illustration)
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWideScreen = constraints.maxWidth > 800;

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: isWideScreen
                        ? Row(
                      children: [
                        _buildLoginForm(flex: 1),
                        Center(
                          child: Container(
                            height: 600, // Custom height of divider
                            child: const VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                              width: 1,
                            ),
                          ),
                        ),
                        _buildIllustration(flex: 1),
                      ],
                    )
                        : Column(
                      children: [
                        _buildIllustration(flex: 0),
                        _buildLoginForm(flex: 0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm({required int flex}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo and Title with subtitle right-aligned
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image_assets/Pinesville - White.png',
                    width: 100,
                    height: 100,
                    semanticLabel: 'Pinesville Logo',
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Pinesville',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 0),
                      Text(
                        'Properties',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'Fast & easy property management',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 100),
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              const SizedBox(height: 60),

              // Email Field
              const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field with toggle
              TextField(
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration({required int flex}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: SvgPicture.asset(
          'assets/image_assets/Operating system upgrade-cuate.svg',
          height: 600,
          width: 500,
        ),
      ),
    );
  }
}
  // @override
  // Widget build(BuildContext context) {
  //   return const Placeholder();
  //
  //
  //   ----------------------- TO BE CONTINUED -----------------------
  //   VIDEO: FLUTTER LOGIN PAGE
  //   TIMESTAMP: 11:41
  //
  //
  //   return Center(
  //     child: SizedBox(
  //       width: 550,
  //       child: SingleChildScrollView(
  //         child: Container(
  //           padding: TSpacingStyle.paddingWithAppBarHeight,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(WebSizes.cardRadiusLg),
  //           ),
  //           child: Column(
  //             children: [
  //               // Header
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: Column(
  //                   children: [
  //                     const Image(width: 100, height: 100, image: AssetImage('pinesville_pasig.png')),
  //
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   )
  // }