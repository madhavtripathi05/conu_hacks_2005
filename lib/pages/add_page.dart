import 'package:conu_hacks_2005/controllers/orders_controller.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

final qItems = ['Count', 'KG', 'grams', 'litre', 'ml'];

class _AddPageState extends State<AddPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  final formKey = GlobalKey<FormState>();
  String selectedQuantity = qItems[0];
  final storeNameController = TextEditingController();
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController(text: "1");
  final addressController = TextEditingController();
  String address = '';
  final orderController = OrderController.instance;

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
          list: itemNameController.text + quantityController.text,
          createdAt: DateTime.now().toString());
    } else {
      // show error
    }
  }
}
