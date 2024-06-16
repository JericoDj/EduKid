import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../screens/homescreen/widgets/promo_slider.dart';
import '../../models/booking_model.dart';
import '../booking_checkout/booking_checkout.dart';

class BookingSessionScreen extends StatefulWidget {
  final List<DateTime> selectedDates;
  final List<TimeOfDay?> selectedTimes;

  const BookingSessionScreen({
    Key? key,
    required this.selectedDates,
    required this.selectedTimes,
  }) : super(key: key);

  @override
  _BookingSessionScreenState createState() => _BookingSessionScreenState();
}

class _BookingSessionScreenState extends State<BookingSessionScreen> {

  final double price = 10; // Define the price to be 10
  List<int> _selectedIndexes = [];
  List<bool> _isSelected = [];
  bool _isSelecting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyPromoSlider(),
            Row(
              children: [
                TextButton(
                  onPressed: () => _toggleSelecting(),
                  child: Text(_isSelecting ? 'Done Editing' : 'Select Date'),
                ),
                Spacer(),
                _selectedIndexes.isNotEmpty
                    ? TextButton(
                  onPressed: () => _deleteSelectedItems(),
                  child: Text('Delete Selected'),
                )
                    : SizedBox(),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedDates.length + 1,
                itemBuilder: (context, index) {
                  if (index == widget.selectedDates.length) {
                    return FloatingActionButton(
                      onPressed: _addDate,
                      child: Icon(Icons.add),
                      backgroundColor: Colors.blue,
                    );
                  }
                  return Column(
                    children: [
                      Dismissible(
                        key: Key(widget.selectedDates[index].toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm"),
                                content: Text(
                                    "Are you sure you want to delete this item?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          _removeDate(index);
                        },
                        child: GestureDetector(
                          onTap: () => _handleTap(index),
                          onLongPress: () => _handleLongPress(index),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedIndexes.contains(index)
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _isSelecting ? null : () => _selectDate(context, index),
                                      child: Text(
                                        'Date ${index + 1}: ${widget.selectedDates[index].day}/${widget.selectedDates[index].month}/${widget.selectedDates[index].year}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10), // Adjust the spacing as needed
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _isSelecting ? null : () => _selectTime(context, index),
                                      child: Row(
                                        children: [
                                          Icon(Icons.access_time), // Keep the icon of the time
                                          SizedBox(width: 5), // Adjust the spacing as needed
                                          Text(
                                            widget.selectedTimes[index] != null
                                                ? widget.selectedTimes[index]!.format(context)
                                                : 'Tap to Edit',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_isSelecting)
                                    Checkbox(
                                      value: _isSelected[index],
                                      onChanged: (value) => _toggleSelected(index),
                                    ),
                                ],
                              ),
                              trailing: !_isSelecting
                                  ? Text(
                                '\$$price',
                                style: TextStyle(fontSize: 16),
                              )
                                  : null, // Hide $10 when selecting
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: MySizes.spaceBtwItems),
                      // Adjust the height as needed
                    ],
                  );
                },
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    List<DateTime> pickedDates = [];
                    List<TimeOfDay?> pickedTimes = [];

                    for (int i = 0; i < widget.selectedDates.length; i++) {
                      pickedDates.add(widget.selectedDates[i]);
                      pickedTimes.add(widget.selectedTimes[i]);
                      // Calculate the total price by adding the price of each widget
                      print(
                          'Index: $i, Picked Date: ${widget.selectedDates[i]}, Picked Time: ${widget.selectedTimes[i]}');
                    }
                    Get.to(
                      BookingCheckOutScreen(
                        pickedDates: pickedDates,
                        pickedTimes: pickedTimes,
                        price: price,
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Book a Session ',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      Text(
                        '\$${widget.selectedDates.length * 10}', // Calculate total price based on the number of selected dates
                        style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),


            SizedBox(height: MySizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: widget.selectedTimes[index] ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        widget.selectedTimes[index] = pickedTime;
        print('Picked Time: $pickedTime');
      });
    }
  }

  void _toggleSelected(int index) {
    setState(() {
      _isSelected[index] = !_isSelected[index];
      if (!_isSelected.any((isSelected) => isSelected)) {
        _isSelecting = false;
      }
      if (!_isSelected[index]) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  void _selectDate(BuildContext context, int index) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDates[index],
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        widget.selectedDates[index] = pickedDate;
        print('Picked Date: $pickedDate');
      });
    }
  }

  void _handleTap(int index) {
    setState(() {
      if (_isSelecting) {
        if (_isSelected[index]) {
          _selectedIndexes.remove(index);
        } else {
          _selectedIndexes.add(index);
        }
        _isSelected[index] = !_isSelected[index];
        _isSelecting = _isSelected.any((isSelected) => isSelected);
      }
    });
  }

  void _handleLongPress(int index) {
    setState(() {
      if (_isSelected[index]) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
      _isSelected[index] = !_isSelected[index];
      _isSelecting = _isSelected.any((isSelected) => isSelected);
    });
  }

  void _addDate() {
    setState(() {
      widget.selectedDates.add(DateTime.now());
      widget.selectedTimes.add(null);
      _isSelected.add(false);
    });
  }

  void _removeDate(int index) {
    setState(() {
      widget.selectedDates.removeAt(index);
      widget.selectedTimes.removeAt(index);
      _isSelected.removeAt(index);
    });
  }

  void _toggleSelecting() {
    setState(() {
      _isSelecting = !_isSelecting;
      if (!_isSelecting) {
        _isSelected.forEach((element) {
          element = false;
        });
        _selectedIndexes.clear();
      } else {
        // If not selecting, clear the selection and add all indexes
        _selectedIndexes.clear();
        for (int i = 0; i < widget.selectedDates.length; i++) {
          _selectedIndexes.add(i);
        }
      }
    });
  }

  void _deleteSelectedItems() {
    setState(() {
      _selectedIndexes.forEach((index) {
        _removeDate(index);
      });
      _selectedIndexes.clear();
    });
  }

  bool _allTimesSelected() {
    for (var time in widget.selectedTimes) {
      if (time == null) {
        return false;
      }
    }
    return true;
  }
}
