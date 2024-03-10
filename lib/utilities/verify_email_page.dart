// import 'package:mynotes/extensions/buildcontext/loc.dart';
// import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:formcapture/pages.dart';

class VerifyEmailPage extends StatefulWidget {
  final String message;
  const VerifyEmailPage({Key? key, required this.message}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.message,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 132, 128, 128),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    side: const BorderSide(color: Colors.grey),
                    fixedSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    'Resend',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () async {
                    // final user = FirebaseAuth.instance.currentUser;
                    // await user?.sendEmailVerification();
                    await AuthService.firebase().sendEmailVerification();
                  },
                ),
                const SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    side: const BorderSide(color: Colors.grey),
                    fixedSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    'Login now',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LogInPage()));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
