import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineListScreen extends StatefulWidget {
  final String pharmacyId;

  const MedicineListScreen({super.key, required this.pharmacyId});

  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Medicines"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search medicine...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: _firestore
                    .collection("pharmacies")
                    .doc(widget.pharmacyId)
                    .collection("medicines")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No medicines available"));
                  }

                  var medicines = snapshot.data!.docs.where((doc) {
                    return doc["name"].toLowerCase().contains(searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      var doc = medicines[index];
                      Map<String, dynamic> medicine = doc.data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(medicine["name"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("💰 Price: ₹${medicine["price"]}"),
                              Text("📝 Description: ${medicine["description"]}"),
                              Text("🔥 Offer: ${medicine["offer"]}"),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditMedicineDialog(doc);
                              } else if (value == 'delete') {
                                _deleteMedicine(doc.id);
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMedicineDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ✅ Add Medicine
  void _showAddMedicineDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController offerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Medicine"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(nameController, "Medicine Name"),
            _buildTextField(priceController, "Price", isNumber: true),
            _buildTextField(descriptionController, "Description"),
            _buildTextField(offerController, "Offer"),
          ],
        ),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            child: const Text("Add"),
            onPressed: () async {
              await _firestore.collection("pharmacies").doc(widget.pharmacyId).collection("medicines").add({
                "name": nameController.text.trim(),
                "price": int.parse(priceController.text.trim()),
                "description": descriptionController.text.trim(),
                "offer": offerController.text.trim(),
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Medicine Added!")));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ✅ Edit Medicine
  void _showEditMedicineDialog(DocumentSnapshot doc) {
    TextEditingController nameController = TextEditingController(text: doc["name"]);
    TextEditingController priceController = TextEditingController(text: doc["price"].toString());
    TextEditingController descriptionController = TextEditingController(text: doc["description"]);
    TextEditingController offerController = TextEditingController(text: doc["offer"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Medicine"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(nameController, "Medicine Name"),
            _buildTextField(priceController, "Price", isNumber: true),
            _buildTextField(descriptionController, "Description"),
            _buildTextField(offerController, "Offer"),
          ],
        ),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            child: const Text("Update"),
            onPressed: () async {
              await _firestore.collection("pharmacies").doc(widget.pharmacyId).collection("medicines").doc(doc.id).update({
                "name": nameController.text.trim(),
                "price": int.parse(priceController.text.trim()),
                "description": descriptionController.text.trim(),
                "offer": offerController.text.trim(),
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Medicine Updated!")));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ✅ Delete Medicine
  void _deleteMedicine(String medicineId) async {
    await _firestore.collection("pharmacies").doc(widget.pharmacyId).collection("medicines").doc(medicineId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Medicine Deleted!")));
  }

  // ✅ Utility function for TextFields
  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
      ),
    );
  }
}