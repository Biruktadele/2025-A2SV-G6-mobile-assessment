import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../widget/Text.dart';
import '../widget/account_nav.dart';
import '../widget/button_widget.dart';
import '../widget/ecom.widget.dart';
import '../widget/input_filed.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    // nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  void _onLoginPressed() {
    final email = emailController.text;
    final password = passwordController.text;
    _clearControllers();
    context.read<AuthBloc>().add(LoginUser(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // body: SingleChildScrollView(
      body:
      SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            const Positioned(
              top: 122,
              left: 124,
              child: EcomWidget(hight: 70, width: 144, size: 48),
            ),
            const Positioned(
              top: 252,
              left: 30,
              child: TextWidget(text: 'Sign into your account'),
            ),
            Positioned(
              top: 316,
              left: 30,
              child: InputFiled(
                label: 'Email',
                hint: 'ex: jon.smith@email.com',
                controller: emailController,
              ),
            ),
            Positioned(
              top: 426,
              left: 30,
              child: InputFiled(
                label: 'Password',
                hint: '*********',
                controller: passwordController,
              ),
            ),
            Positioned(
              top: 546,
              left: 30,
              child: ButtonWidget(text: 'Sign In', onPressed: _onLoginPressed),
            ),
            const Positioned(
              top: 696,
              left: 30,
              child: AccountNav(
                nav: 'Sign Up',
                text: 'Don\'t have an account?',
                page: SignUpPage(),
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AuthSuccess) {
                  return const Center(child: Text('Login Success'));
                }
                if (state is AuthFailure) {
                  return Center(child: Text(state.failure.message));
                }
                return const Center(child: Text(''));
              },
            ),
          ],
        ),
      ),
      ),
    );  
  }
}
