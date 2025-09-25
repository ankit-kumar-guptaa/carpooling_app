import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AvailableRidesScreen extends StatefulWidget {
  final String? source;
  final String? destination;

  const AvailableRidesScreen({
    Key? key,
    this.source,
    this.destination,
  }) : super(key: key);

  @override
  _AvailableRidesScreenState createState() => _AvailableRidesScreenState();
}

class _AvailableRidesScreenState extends State<AvailableRidesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Map<String, dynamic>> _availableRides = [
    {
      'driver': 'Rahul Sharma',
      'rating': 4.8,
      'car': 'Swift Dzire',
      'seats': 3,
      'price': 250,
      'time': '10:30 AM',
      'date': 'Today',
      'source': 'Andheri East',
      'destination': 'Bandra West',
      'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    {
      'driver': 'Priya Patel',
      'rating': 4.9,
      'car': 'Honda City',
      'seats': 2,
      'price': 320,
      'time': '11:15 AM',
      'date': 'Today',
      'source': 'Andheri East',
      'destination': 'Bandra West',
      'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'driver': 'Amit Kumar',
      'rating': 4.7,
      'car': 'Hyundai i20',
      'seats': 3,
      'price': 280,
      'time': '12:00 PM',
      'date': 'Today',
      'source': 'Andheri East',
      'destination': 'Bandra West',
      'avatar': 'https://randomuser.me/api/portraits/men/62.jpg',
    },
    {
      'driver': 'Neha Gupta',
      'rating': 4.6,
      'car': 'Toyota Etios',
      'seats': 4,
      'price': 300,
      'time': '01:30 PM',
      'date': 'Today',
      'source': 'Andheri East',
      'destination': 'Bandra West',
      'avatar': 'https://randomuser.me/api/portraits/women/26.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Available Rides',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRouteInfo(),
            Expanded(
              child: _availableRides.isEmpty
                  ? _buildNoRidesFound()
                  : _buildRidesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Route',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Column(
                children: [
                  Icon(
                    Icons.circle,
                    color: AppColors.primaryGreen,
                    size: 12,
                  ),
                  Container(
                    height: 30,
                    width: 1,
                    color: Colors.grey,
                  ),
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 12,
                  ),
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.source ?? 'Andheri East',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20),
                    Text(
                      widget.destination ?? 'Bandra West',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(
                '${_availableRides.length} rides available',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              Spacer(),
              Text(
                'Sort by: ',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Price',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoRidesFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_transfer,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No rides available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try changing your route or time',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRidesList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _availableRides.length,
      itemBuilder: (context, index) {
        final ride = _availableRides[index];
        
        // Create staggered animation for each item
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              index * 0.1,
              0.1 + index * 0.1,
              curve: Curves.easeOut,
            ),
          ),
        );
        
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.5, 0),
              end: Offset.zero,
            ).animate(animation),
            child: _buildRideCard(ride),
          ),
        );
      },
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    ride['avatar'],
                  ),
                  onBackgroundImageError: (_, __) {},
                  child: Icon(Icons.person),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride['driver'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${ride['rating']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' • ${ride['car']}',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${ride['price']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    Text(
                      'per seat',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.circle,
                      color: AppColors.primaryGreen,
                      size: 10,
                    ),
                    Container(
                      height: 25,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 10,
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride['source'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 16),
                      Text(
                        ride['destination'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ride['time'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      ride['date'],
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.airline_seat_recline_normal,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${ride['seats']} seats left',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Booking feature coming soon!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Book Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}