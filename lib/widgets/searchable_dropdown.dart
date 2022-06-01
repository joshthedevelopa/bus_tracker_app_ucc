import '../imports.dart';

class SearchDropdownItem {
  final Widget? display;
  final dynamic value;
  final String title;
  final String? subtitle;

  SearchDropdownItem({
    this.display,
    this.subtitle,
    required this.title,
    required this.value,
  });
}

class SearchableDropdown extends StatefulWidget {
  final List<SearchDropdownItem> items;
  final Function(Location) onChanged;

  const SearchableDropdown({
    Key? key,
    this.items = const [],
    required this.onChanged
  }) : super(key: key);

  @override
  _SearchableDropdownState createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();

  final ValueNotifier<bool> _showCloseButton = ValueNotifier(false);
  final ValueNotifier<String> _searchedValue = ValueNotifier("");

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeInOut,
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _animationController.duration = const Duration(milliseconds: 1200);
        _animationController.forward();
      } else {
        _animationController.duration = const Duration(milliseconds: 500);
        _animationController.reverse();
      }

      _showCloseButton.value = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCard(
          width: double.infinity,
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  size: 22.0,
                  color: Colors.blueGrey.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 4.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    focusNode: _focusNode,
                    onChanged: (value) {
                      _searchedValue.value = value;
                    },
                    onSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    style: const TextStyle(
                      color: ColorTheme.secondary,
                    ),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: "Location search...",
                      hintStyle: TextStyle(
                        color: ColorTheme.secondary.withOpacity(
                          0.35,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _showCloseButton,
                builder: (context, _value, child) {
                  if (_value) {
                    return child!;
                  }
                  return const SizedBox(
                    width: 42.0,
                    height: 42.0,
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  child: InkResponse(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.close,
                        color: ColorTheme.primary,
                        size: 22.0,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ScaleTransition(
            scale: _animation,
            child: Align(
              alignment: Alignment.topCenter,
              child: CustomCard(
                width: double.infinity,
                margin: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder<String>(
                  valueListenable: _searchedValue,
                  builder: (context, _search, child) {
                    List<SearchDropdownItem> _tmpList = [];

                    _tmpList = widget.items.where((element) {
                      String _value = element.title.toLowerCase();

                      return _value.contains(
                        _search.toLowerCase(),
                      );
                    }).toList();

                    if (_tmpList.isEmpty) {
                      return Center(
                        child: Text(
                          "No Location...",
                          style: TextStyle(
                            color: Colors.blueGrey.withOpacity(0.5),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _tmpList.length,
                      separatorBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 36.0,
                            vertical: 8.0,
                          ),
                          child: Material(
                            color: Colors.blueGrey.withOpacity(0.2),
                            child: const SizedBox(
                              width: double.infinity,
                              height: 1.0,
                            ),
                          ),
                        );
                      },
                      itemBuilder: (context, index) {
                        SearchDropdownItem _item = _tmpList[index];

                        return _customListTile(_item);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  IntrinsicHeight _customListTile(SearchDropdownItem _item) {
    return IntrinsicHeight(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if(_focusNode.hasFocus) {
              _focusNode.unfocus();
            }
            widget.onChanged(_item.value);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(radius: 20),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _item.title,
                        style: const TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                      if (_item.subtitle != null)
                        Text(
                          _item.subtitle!,
                          style: TextStyle(
                            color: Colors.blueGrey.withOpacity(0.6),
                            fontSize: 12.0,
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
