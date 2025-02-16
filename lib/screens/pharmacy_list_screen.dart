import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'medicine_list_screen.dart';

class PharmacyListScreen extends StatefulWidget {
  const PharmacyListScreen({super.key});

  @override
  _PharmacyListScreenState createState() => _PharmacyListScreenState();
}

class _PharmacyListScreenState extends State<PharmacyListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pharmacy List"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _firestore.collection("pharmacies").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No pharmacies available. Click the + button to add one!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> pharmacy = doc.data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(
                    pharmacy["Name"],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📍 Location: ${pharmacy["Location"]}"),
                      const SizedBox(height: 5),
                      const Divider(thickness: 1),
                      const SizedBox(height: 5),
                      Text(
                        "Tap to manage medicines",
                        style: TextStyle(color: Colors.deepPurple.shade400, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicineListScreen(pharmacyId: doc.id),
                      ),
                    );
                  },
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditPharmacyDialog(doc);
                      } else if (value == 'delete') {
                        _deletePharmacy(doc.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text("Edit")),
                      const PopupMenuItem(value: 'delete', child: Text("Delete")),
                    ],
                    icon: const Icon(Icons.more_vert),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPharmacyDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPharmacyDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Pharmacy"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(nameController, "Pharmacy Name"),
            _buildTextField(locationController, "Location"),
          ],
        ),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            child: const Text("Add"),
            onPressed: () async {
              if (nameController.text.isNotEmpty && locationController.text.isNotEmpty) {
                await _firestore.collection("pharmacies").add({
                  "Name": nameController.text.trim(),
                  "Location": locationController.text.trim(),
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pharmacy Added!")));
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditPharmacyDialog(DocumentSnapshot doc) {
    TextEditingController nameController = TextEditingController(text: doc["Name"]);
    TextEditingController locationController = TextEditingController(text: doc["Location"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Pharmacy"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(nameController, "Pharmacy Name"),
            _buildTextField(locationController, "Location"),
          ],
        ),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            child: const Text("Update"),
            onPressed: () async {
              await _firestore.collection("pharmacies").doc(doc.id).update({
                "Name": nameController.text.trim(),
                "Location": locationController.text.trim(),
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pharmacy Updated!")));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _deletePharmacy(String id) async {
    await _firestore.collection("pharmacies").doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pharmacy Deleted!")));
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}