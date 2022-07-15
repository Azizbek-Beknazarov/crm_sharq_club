import 'package:crm_sharq_club/features/customer/cars/presentation/page/add_edit_page.dart';
import 'package:flutter/material.dart';



class AddFloatingButton extends StatelessWidget {
  const AddFloatingButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => AddEditPage(
                      isEditing: false,
                    )),
          );
        });
  }
}