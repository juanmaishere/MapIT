import '../location/presentation/blocs/location_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../assets/mapstyles.dart';

class SlidingButtonWidget extends StatefulWidget {
  @override
  final VoidCallback onMapStyleChanged;

  const SlidingButtonWidget({required this.onMapStyleChanged});
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
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.map,
              color: const Color.fromRGBO(255, 255, 255, 1),
            ),
            if (showButtons)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showButtons = false;
                      });
                      // Handle the first button tap
                      context
                          .read<LocationBloc>()
                          .add(ChangeMapStyle(mapStyle1));
                      widget.onMapStyleChanged();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(5.0), // Adjust padding for size
                    ),
                    child: const Icon(
                      Icons.map,
                      size: 20.0, // Set icon size
                      color: Color.fromARGB(255, 249, 16, 16),
                    ),
                  ),
                  SizedBox(width: 4.0),
                  ElevatedButton(
                    onPressed: () {
                      // Handle the second button tap
                      context
                          .read<LocationBloc>()
                          .add(ChangeMapStyle(mapStyle2));
                      widget.onMapStyleChanged();
                      setState(() {
                        showButtons = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(5.0), // Adjust padding for size
                    ),
                    child: const Icon(
                      Icons.map,
                      size: 20.0, // Set icon size
                      color: Color.fromARGB(255, 2, 2, 2),
                    ),
                  ),
                  SizedBox(width: 4.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showButtons = false;
                      });
                      // Handle the third button tap
                      context
                          .read<LocationBloc>()
                          .add(ChangeMapStyle(mapStyle3));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(5.0), // Adjust padding for size
                    ),
                    child: const Icon(
                      Icons.map,
                      size: 20.0, // Set icon size
                      color: Color.fromARGB(255, 25, 156, 217),
                    ),
                  ),
                  SizedBox(width: 4.0),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
