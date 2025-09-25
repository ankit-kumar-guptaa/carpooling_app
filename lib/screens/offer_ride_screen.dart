import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'search_screen.dart';

class OfferRideScreen extends StatefulWidget {
  const OfferRideScreen({Key? key}) : super(key: key);

  @override
  _OfferRideScreenState createState() => _OfferRideScreenState();
}

class _OfferRideScreenState extends State<OfferRideScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();

  String _source = '';
  String _destination = '';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  int _availableSeats = 2;
  double _pricePerSeat = 200;
  String _carModel = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryGreen),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryGreen),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Show success animation and navigate back
        _showSuccessDialog();
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: value,
                            color: AppColors.primaryGreen,
                            strokeWidth: 8,
                          ),
                        ),
                        Icon(
                          Icons.check,
                          color: AppColors.primaryGreen,
                          size: 40,
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Ride Offered Successfully!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Your ride has been posted. You will be notified when someone books a seat.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Offer a Ride',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Route Details'),
                        _buildSourceDestinationFields(),
                        SizedBox(height: 24),

                        _buildSectionTitle('Journey Details'),
                        _buildDateTimeFields(),
                        SizedBox(height: 24),

                        _buildSectionTitle('Car Details'),
                        _buildCarDetailsFields(),
                        SizedBox(height: 24),

                        _buildSectionTitle('Seat & Price'),
                        _buildSeatsPriceFields(),
                        SizedBox(height: 32),

                        _buildSubmitButton(),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSourceDestinationFields() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                // FIXED: Pass arguments through constructor or settings
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                      isSource: true,
                      // Remove initialValue and handle it in SearchScreen constructor
                    ),
                    settings: RouteSettings(
                      arguments: {'isSource': true, 'initialValue': _source},
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _source = result;
                  });
                }
              },
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Pickup Location',
                  hintText: 'Enter pickup location',
                  prefixIcon: Icon(
                    Icons.circle,
                    color: AppColors.primaryGreen,
                    size: 12,
                  ),
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (_source.isEmpty) {
                    return 'Please enter pickup location';
                  }
                  return null;
                },
                controller: TextEditingController(text: _source),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                // FIXED: Pass arguments through constructor or settings
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                      isSource: false,
                      // Remove initialValue and handle it in SearchScreen constructor
                    ),
                    settings: RouteSettings(
                      arguments: {
                        'isSource': false,
                        'initialValue': _destination,
                      },
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _destination = result;
                  });
                }
              },
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Drop Location',
                  hintText: 'Enter drop location',
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 12,
                  ),
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (_destination.isEmpty) {
                    return 'Please enter drop location';
                  }
                  return null;
                },
                controller: TextEditingController(text: _destination),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeFields() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  controller: TextEditingController(
                    text: '${_date.day}/${_date.month}/${_date.year}',
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(context),
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Time',
                    prefixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  controller: TextEditingController(
                    text: '${_time.format(context)}',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarDetailsFields() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Car Model',
            hintText: 'e.g. Honda City, Swift Dzire',
            prefixIcon: Icon(Icons.directions_car),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter car model';
            }
            return null;
          },
          onSaved: (value) {
            _carModel = value!;
          },
        ),
      ),
    );
  }

  Widget _buildSeatsPriceFields() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Available Seats',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                _buildSeatCounter(),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Price per Seat',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                _buildPriceSlider(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatCounter() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (_availableSeats > 1) {
                setState(() {
                  _availableSeats--;
                });
              }
            },
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$_availableSeats',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (_availableSeats < 6) {
                setState(() {
                  _availableSeats++;
                });
              }
            },
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '₹${_pricePerSeat.toInt()}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        Container(
          width: 200,
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primaryGreen,
              thumbColor: AppColors.primaryGreen,
              overlayColor: AppColors.primaryGreen.withOpacity(0.2),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              min: 50,
              max: 500,
              divisions: 45,
              value: _pricePerSeat,
              onChanged: (value) {
                setState(() {
                  _pricePerSeat = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Hero(
      tag: 'offer_ride_button',
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Offer Ride',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
