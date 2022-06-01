import '../imports.dart';

class IntroView extends StatefulWidget {
  const IntroView({Key? key}) : super(key: key);

  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  bool isLoading = false;
  String name = "", index = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset("assets/images/login_bg.jpg"),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              color: ColorTheme.secondary.withOpacity(0.9),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: SizedBox()),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 30.0, letterSpacing: 1.2),
                        children: [
                          TextSpan(
                            text: "Bus ",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextSpan(text: "Tracker"),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Please enter in your name and index number to proceed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    InputField(
                      label: "Full Name",
                      onChanged: (String value) {
                        name = value.sentenceCase();
                      },
                    ),
                    const SizedBox(height: 8.0),
                    InputField(
                      label: "Index Number",
                      onChanged: (String value) {
                        index = value.toUpperCase();
                      },
                    ),
                    const Expanded(child: SizedBox()),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: InkResponse(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            Future.delayed(
                              const Duration(seconds: 3),
                            ).then((value) {
                              if (name != "" && index != "") {
                                Storage.setBool("loggedIn", true);
                                Storage.set("name", name);
                                Storage.set("index", index);

                                setState(() {
                                  isLoading = false;
                                });

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const HomeView();
                                    },
                                  ),
                                );
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            });
                          },
                          child: const CircleAvatar(
                            backgroundColor: ColorTheme.primary,
                            radius: 30,
                            child: Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Material(
                    color: ColorTheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const SizedBox(
                      width: 120,
                      height: 120,
                      child: Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              ColorTheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final Function(String value)? onChanged;

  const InputField({Key? key, this.label = "", this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 12.0,
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          CustomCard(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(
                color: ColorTheme.secondary,
              ),
              decoration: const InputDecoration.collapsed(hintText: ""),
            ),
          ),
        ],
      ),
    );
  }
}
