import '../location/presentation/blocs/location_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../assets/mapstyles.dart';

class SlidingButtonWidget extends StatefulWidget {
  @override
  final VoidCallback? onTapCallback;
  final VoidCallback? onTapCallback2;
  final VoidCallback? onTapCallback3;
  const SlidingButtonWidget(
      {this.onTapCallback, this.onTapCallback2, this.onTapCallback3});
  _SlidingButtonWidgetState createState() => _SlidingButtonWidgetState();
}

class _SlidingButtonWidgetState extends State<SlidingButtonWidget> {
  bool showButtons = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showButtons = !showButtons;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: showButtons
              ? Color.fromARGB(0, 255, 255, 255)
              : Color.fromARGB(255, 2, 25, 34),
        ),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height / 2 + 45,
          right: showButtons ? 2 : 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                margin: EdgeInsets.all(4),
                child: Icon(
                  showButtons
      ? Icons.cancel // Icon when showButtons is true
      : Icons.map, 
                  color: showButtons
                      ? Color.fromARGB(255, 243, 24, 24)
                      : Color.fromARGB(255, 255, 255, 255),
                  size: 20,
                )),
            if (showButtons)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.onTapCallback?.call();
                      setState(() {
                        showButtons = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(0.1),
                    ),
                    child: const Icon(
                      Icons.map,
                      size: 20.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.onTapCallback2?.call();
                      setState(() {
                        showButtons = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(0.1),
                    ),
                    child: const Icon(
                      Icons.map,
                      size: 20.0,
                      color: Color.fromARGB(255, 216, 176, 89),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.onTapCallback3?.call();
                      setState(() {
                        showButtons = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(0.1),
                    ),
                    child: const Icon(
                      Icons.map,
                      size: 20.0,
                      color: Color.fromARGB(255, 55, 240, 79),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
