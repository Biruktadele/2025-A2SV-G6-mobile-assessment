import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../widget/Text.dart';
import '../widget/account_nav.dart';
import '../widget/button_widget.dart';
import '../widget/ecom.widget.dart';
import '../widget/input_filed.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    // final confirmPassword = confirmPasswordController.text;
    context.read<AuthBloc>().add(RegisterUser(name, email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body:
      SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is AuthSuccess) {
                return const Center(child: Text('Register Success'));
              }
              if (state is AuthFailure) {
                return Center(child: Text(state.failure.message));
              }
              return const Center(child: Text(''));
            },
          ),
          const Positioned(
            top: 65,
            left: 270,
            child: EcomWidget(hight: 35, width: 82, size: 22),
          ),
          const Positioned(
            top: 152,
            left: 30,
            child: TextWidget(text: 'Create your account'),
          ),
          Positioned(
            top: 214,
            left: 30,
            child: InputFiled(
              label: 'Name',
              hint: 'ex: jon smith',
              controller: nameController,
            ),
          ),
          Positioned(
            top: 296,
            left: 30,
            child: InputFiled(
              label: 'Email',
              hint: 'ex: jon.smith@email.com',
              controller: emailController,
            ),
          ),
          Positioned(
            top: 380,
            left: 30,
            child: InputFiled(
              label: 'Password',
              hint: '*********',
              controller: passwordController,
            ),
          ),
          Positioned(
            top: 463,
            left: 30,
            child: InputFiled(
              label: 'Confirm Password',
              hint: '*********',
              controller: confirmPasswordController,
            ),
          ),
          Positioned(
            top: 578,
            left: 30,
            child: ButtonWidget(text: 'Sign Up', onPressed: _onSignUpPressed),
          ),
          const Positioned(
            top: 696,
            left: 30,
            child: AccountNav(
              nav: 'Login',
              text: 'Already have an account?',
              page: LoginPage(),
            ),
          ),
        ],
      ),
      ),
      ),
    );
  }
}
