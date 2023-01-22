import 'package:conu_hacks_2005/controllers/group_controller.dart';
import 'package:conu_hacks_2005/models/group.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final groupController = GroupController.instance;

  Future<void> init() async {
    await groupController.fetchGroups();
  }

  final nameController = TextEditingController();

  bool enableButton = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(backgroundImage: AssetImage("assets/images/logo.jpeg")),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Groups',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, ss) {
                        return AlertDialog(
                          title: const Text("Enter Group name"),
                          content: TextField(
                            controller: nameController,
                            onChanged: ((value) {
                              if (value.isNotEmpty) {
                                ss(() => enableButton = true);
                              } else {
                                ss(() => enableButton = false);
                              }
                            }),
                          ),
                          actions: [
                            MaterialButton(
                              onPressed: Navigator.of(context).pop,
                              child: const Text("Cancel"),
                            ),
                            MaterialButton(
                              onPressed: enableButton
                                  ? () async {
                                      Navigator.of(context).pop();
                                      await groupController.createGroup(name: nameController.text);
                                      nameController.clear();
                                    }
                                  : null,
                              child: const Text("Create Group"),
                            ),
                          ],
                        );
                      });
                    });
              },
              icon: const Icon(Icons.add, color: Colors.black)),
          IconButton(
              onPressed: groupController.joinGroup,
              icon: const Icon(
                Icons.qr_code,
                color: Colors.black,
              )),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<List<Group>?>(
            stream: groupController.groupsSubject,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              final groups = snapshot.data ?? [];
              if (groups.isEmpty) {
                return const Center(
                  child: Text('You haven\'t created or joined group'),
                );
              }
              return ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, i) {
                    final group = groups[i];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder: (context, ss) {
                                return AlertDialog(
                                    title: const Text("Scan QR to join this group"),
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 200,
                                          width: 200,
                                          child: QrImage(
                                            data: group.groupId,
                                            version: QrVersions.auto,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      MaterialButton(
                                        onPressed: Navigator.of(context).pop,
                                        child: const Text("Done"),
                                      ),
                                    ]);
                              });
                            });
                      },
                      child: Card(
                        child: ListTile(
                          leading: Image.network(
                            "https://ui-avatars.com/api/?format=png&name=${group.groupName}&rounded=true",
                            height: 40,
                            width: 40,
                          ),
                          title: Text(
                            group.groupName,
                            style: const TextStyle(fontSize: 20),
                          ),
                          subtitle: Text('${group.members} members'),
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
