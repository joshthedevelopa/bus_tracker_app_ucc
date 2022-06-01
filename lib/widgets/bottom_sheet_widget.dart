import '../imports.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    Key? key,
    this.action,
    required this.title,
    required this.subtitle,
    required this.description,
    this.locate,
    this.image,
    required EdgeInsets screenInsets,
  })  : _screenInsets = screenInsets,
        super(key: key);

  final EdgeInsets _screenInsets;
  final Widget? image;
  final String title, subtitle, description;
  final VoidCallback? action, locate;

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 1100),
      curve: Curves.elasticOut,
      bottom: isExpanded ? 0 : -140,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(
          top: widget._screenInsets.top + 8.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkResponse(
                  onTap: () {
                    widget.action?.call();
                    // setState(() {
                    //   isExpanded = !isExpanded;
                    // });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.decelerate,
                      turns: isExpanded ? .5 : 0,
                      child: const Icon(
                        Icons.arrow_upward_sharp,
                        color: ColorTheme.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Stack(
            //   children: [
            //     // Align(
            //     //   alignment: Alignment.centerRight,
            //     //   child: CustomCard(
            //     //     margin: const EdgeInsets.all(16.0),
            //     //     radius: 400,
            //     //     padding: EdgeInsets.zero,
            //     //     child: Material(
            //     //       shape: const CircleBorder(),
            //     //       color: ColorTheme.primary,
            //     //       child: Padding(
            //     //         padding: EdgeInsets.zero,
            //     //         child: IconButton(
            //     //           iconSize: 24,
            //     //           onPressed: widget.action,
            //     //           icon: const Icon(
            //     //             Icons.person,
            //     //             color: Colors.white,
            //     //           ),
            //     //         ),
            //     //       ),
            //     //     ),
            //     //   ),
            //     // ),
            //   ],
            // ),
            CustomCard(
              radius: 15.0,
              width: double.infinity,
              padding: EdgeInsets.zero,
              child: Material(
                color: Colors.transparent,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0).copyWith(
                          right: 8.0,
                        ),
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: ColorTheme.secondary,
                          child: widget.image ??
                              const SizedBox(
                                height: 80,
                                width: 80,
                                child: Center(
                                  child: Icon(
                                    Icons.pin_drop,
                                    size: 28.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0).copyWith(
                            right: 16.0,
                            bottom: 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.title,
                                      style: const TextStyle(
                                        color: ColorTheme.secondary,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ).copyWith(top: 10.0),
                                    child: const Material(
                                      shape: CircleBorder(),
                                      color: ColorTheme.primary,
                                      child: SizedBox(
                                        width: 3,
                                        height: 3,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.subtitle,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      color: ColorTheme.primary,
                                      height: 1.8,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                widget.description,
                                maxLines: 2,
                                style: const TextStyle(
                                  color: ColorTheme.secondary,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.0,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkResponse(
                                  onTap: widget.locate,
                                  child: const Icon(
                                    Icons.gps_fixed,
                                    color: ColorTheme.secondary,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
