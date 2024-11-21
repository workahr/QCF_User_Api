import 'package:flutter/material.dart';

class CancelBookingPage extends StatefulWidget {
  @override
  _CancelBookingPageState createState() => _CancelBookingPageState();
}

class _CancelBookingPageState extends State<CancelBookingPage> {
  String? selectedReason;
  TextEditingController descriptionController = TextEditingController();

  final List<String> reasons = [
    "Changed mind",
    "Ordered by mistake",
    "Wrong items in cart",
    "Long delivery time",
    "Other"
  ];

  void _submitCancellation() {
    // Handle the submission of the cancellation reason and description here
    // For example, send data to a server or show a confirmation dialog
    print("Selected reason: $selectedReason");
    print("Description: ${descriptionController.text}");
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cancel Booking"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        // Wrap the body content with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Please Select the Reason of Cancellation",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: reasons.map((reason) {
              return RadioListTile<String>(
                title: Text(reason),
                value: reason,
                groupValue: selectedReason,
                activeColor: Color(0xFFE23744),
                onChanged: (value) {
                  setState(() {
                    selectedReason = value;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: "Description",
              focusColor: Colors.grey,
              labelStyle: TextStyle(
                color: descriptionController.text.isEmpty
                    ? Colors.black
                    : Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 216, 215, 215),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 206, 206, 206),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            maxLines: 4,
          ),
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
          child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: _submitCancellation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE23744),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text("Submit", style: TextStyle(fontSize: 16)),
        ),
      )),
    );
  }
}
