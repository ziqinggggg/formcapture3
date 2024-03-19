import 'package:formcapture/imports.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  StreamController<int> _timerStream = StreamController<int>();
  late int timerCounter;
  late Timer _resendCodeTimer;
  static const _timerDuration = 120;

  @override
  void initState() {
    activeCounter();
    super.initState();
  }

  @override
  dispose() {
    _timerStream.close();
    _resendCodeTimer.cancel();

    super.dispose();
  }

  activeCounter() {
    _resendCodeTimer =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_timerDuration - timer.tick > 0)
        _timerStream.sink.add(_timerDuration - timer.tick);
      else {
        _timerStream.sink.add(0);
        _resendCodeTimer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Object>(
        stream: _timerStream.stream,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 230,
                  ),
                  const Icon(
                    Icons.mark_email_unread,
                    size: 150,
                  ),
                  const Text(
                    'Verify Your Email',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                        "We've sent you an email verification. Please check to verify your account.",
                        style: TextStyle(
                          fontSize: 20,
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
                          backgroundColor:
                              const Color.fromARGB(255, 132, 128, 128),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          side: const BorderSide(color: Colors.grey),
                          fixedSize: const Size.fromHeight(50),
                        ),
                        onPressed: snapshot.data == 0
                            ? () {
                                context.read<AuthBloc>().add(
                                      const AuthEventSendEmailVerification(),
                                    );
                                _timerStream.sink.add(_timerDuration);
                                activeCounter();
                              }
                            : null,
                        child: Text(
                          snapshot.data == 0
                              ? 'Resend'
                              : 'Resend (${snapshot.hasData ? snapshot.data.toString() : 60}s)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),

                        // () async {
                        //   // final user = FirebaseAuth.instance.currentUser;
                        //   // await user?.sendEmailVerification();
                        //   // await AuthService.firebase().sendEmailVerification();
                        //   context.read<AuthBloc>().add(
                        //         const AuthEventSendEmailVerification(),
                        //       );
                        // },
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
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const LogInPage(),
                          //   ),
                          // );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
