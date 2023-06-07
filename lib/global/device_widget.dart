import 'package:battery_percentage/global/decorations.dart';
import 'package:battery_percentage/global/device_list.dart';
import 'package:flutter/material.dart';

class DeviceWidget extends StatefulWidget {
  final Device device;
  Function()? onDeletePressed;
  DeviceWidget({Key? key, required this.device, this.onDeletePressed})
      : assert(device != null),
        super(key: key);

  @override
  State<DeviceWidget> createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: new BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromARGB(50, 158, 158, 158),
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 20.0,
          spreadRadius: 1.0,
        ),
      ]),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: mydecoration(radius: 20),
          child: ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.all(10),
            leading: Icon(
              Icons.bluetooth,
              size: 30,
              color: Colors.black,
            ),
            title: Text(
              widget.device.value1,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              widget.device.value2,
              style: TextStyle(fontSize: 16),
            ),
            trailing: IconButton(
              onPressed: widget.onDeletePressed,
              icon: Icon(
                Icons.delete,
                size: 30,
              ),
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
