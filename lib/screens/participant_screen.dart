/*
* On this screen the user can create or edit a singluar participant
* The user can enter the name, email and household of the participant
* as well as deleting the participant
*/
import 'package:flutter/material.dart';

class ParticipantScreen extends StatelessWidget {
  // constants
  final String title = "Participant";
  final TextEditingController textController = TextEditingController();
  // state of our participant form used to validate all fields of the form
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String _validateName(String value) {
    if (value.length < 2) {
      return "Error Name Can't Be Empty";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // TODO add toolbar to the app bar
        appBar: AppBar(title: Text(this.title)),
        // participant form
        body: Form(
            key: _key, // asign the form key
            // have the form validate each field after the user interacts with it
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
                // align items in the center of the screen
                crossAxisAlignment: CrossAxisAlignment.center,
                // participant form
                children: [
                  // Name field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // white space
                      Expanded(
                        child: Container(
                          height: 1,
                        ),
                        flex: 1,
                      ),
                      // Name field
                      Expanded(
                        child: Padding(
                          child: TextFormField(
                              controller: textController,
                              decoration: InputDecoration(
                                labelText: "Name",
                                helperText: "*Required",
                                border: OutlineInputBorder(),
                              ),
                              validator: _validateName),
                          padding: EdgeInsets.only(top: 16),
                        ),
                        flex: 4,
                      ),
                      // whitespace
                      Expanded(
                        child: Container(
                          height: 1,
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                          onPressed: () {
                            // TODO replace with save button

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(textController.text)));
                          },
                          icon: Icon(Icons.save),
                          label: Text("Save"))
                    ],
                  )
                ])));
  }
}
