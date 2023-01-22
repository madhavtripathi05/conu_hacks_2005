import 'package:conu_hacks_2005/controllers/group_controller.dart';
import 'package:conu_hacks_2005/controllers/orders_controller.dart';
import 'package:flutter/material.dart';

import '../models/group.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

final qItems = ['item', 'KG', 'grams', 'litre', 'ml'];

class _AddPageState extends State<AddPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void init() async {
    await GroupController.instance.fetchGroups();
    selectedGroup = GroupController.instance.groupsSubject.value?.first;
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  String selectedQuantity = qItems[0];
  final storeNameController = TextEditingController();
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController(text: "1");
  final addressController = TextEditingController();
  String address = '';
  final orderController = OrderController.instance;
  Group? selectedGroup = GroupController.instance.groupsSubject.value?.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: Navigator.of(context).pop,
        ),
        backgroundColor: Colors.white,
        title: GestureDetector(
          onVerticalDragDown: (details) {
            if (details.globalPosition.dy > 50) {
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Order request',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [MaterialButton(onPressed: sendRequest, child: const Text('Save'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: formKey,
          child: ListView(children: [
            Row(
              children: const [
                Text('Store name'),
                Text('*', style: TextStyle(color: Colors.red)),
              ],
            ),
            TextFormField(
              controller: storeNameController,
              validator: (s) => s?.isEmpty ?? true ? "Please enter store name!" : null,
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Text('Item Name'),
                Text('*', style: TextStyle(color: Colors.red)),
              ],
            ),
            TextFormField(
              controller: itemNameController,
              validator: (s) => s?.isEmpty ?? true ? "Please enter item name!" : null,
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Text('Quantity'),
                Text('*', style: TextStyle(color: Colors.red)),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: quantityController,
                    validator: (s) => s?.isEmpty ?? true ? "Please enter something!" : null,
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedQuantity,
                    items: qItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (s) {
                      selectedQuantity = s ?? '';
                      setState(() {});
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Group'),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton<Group>(
                          value: selectedGroup,
                          items: (GroupController.instance.groupsSubject.value ?? []).map((value) {
                            return DropdownMenuItem<Group>(
                              value: value,
                              child: Text(value.groupName),
                            );
                          }).toList(),
                          onChanged: (s) {
                            selectedGroup = s;

                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Text('Address'),
                Text(' (optional)', style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
            TextFormField(
              controller: addressController,
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> sendRequest() async {
    if (formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop();
      await orderController.addOrder(
          address: addressController.text,
          storeName: storeNameController.text,
          list: "${itemNameController.text}: ${quantityController.text} $selectedQuantity",
          groupId: selectedGroup?.groupId ?? '',
          createdAt: DateTime.now().toString());
    } else {
      // show error
    }
  }
}
