import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'search_screen.dart';
import 'available_rides_screen.dart';
import 'offer_ride_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _selectedTabIndex = 0; // 0 for Find Ride, 1 for Offer Ride
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Image.asset(
            'lib/assets/images/logo.png',
            height: 180,
            width: 180,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.directions_car,
                color: AppColors.primaryGreen,
                size: 50,
              );
            },
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: AppColors.primaryGreen,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                Text(
                  'Hello, User!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Where are you going today?',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 24),

                // Find Ride / Offer Ride tabs
                _buildRideTabs(),
                SizedBox(height: 16),

                // Source and destination fields or Offer ride form based on selected tab
                _selectedTabIndex == 0
                    ? _buildSourceDestinationCard()
                    : _buildOfferRideButton(),
                SizedBox(height: 24),

                // Latest rides section (only show in Find Ride tab)
                if (_selectedTabIndex == 0) _buildLatestRidesSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildRideTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0
                      ? AppColors.primaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Find Ride',
                    style: TextStyle(
                      color: _selectedTabIndex == 0
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1
                      ? AppColors.primaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Offer Ride',
                    style: TextStyle(
                      color: _selectedTabIndex == 1
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferRideButton() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.directions_car, size: 60, color: AppColors.primaryGreen),
            SizedBox(height: 16),
            Text(
              'Offer a ride and share your journey',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Help reduce carbon footprint by sharing your ride with others',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OfferRideScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Offer a Ride',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceDestinationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Source field
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(isSource: true),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: AppColors.primaryGreen, size: 16),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Enter pickup location',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            // Destination field
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(isSource: false),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 16),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Enter drop location',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Find rides button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Finding rides...')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Find Rides',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestRidesSection() {
    // Dummy data for latest rides
    final List<Map<String, dynamic>> latestRides = [
      {
        'source': 'Andheri East',
        'destination': 'Powai',
        'date': 'Today, 5:30 PM',
        'price': '₹120',
        'seats': 2,
      },
      {
        'source': 'Bandra West',
        'destination': 'BKC',
        'date': 'Tomorrow, 9:00 AM',
        'price': '₹150',
        'seats': 3,
      },
      {
        'source': 'Malad West',
        'destination': 'Goregaon East',
        'date': 'Today, 7:00 PM',
        'price': '₹100',
        'seats': 1,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Rides',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        ...latestRides.map((ride) => _buildRideCard(ride)).toList(),
      ],
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source and destination
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: AppColors.primaryGreen,
                            size: 12,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              ride['source'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Container(
                          height: 20,
                          width: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red, size: 12),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              ride['destination'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
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
                      ride['price'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    Text(
                      '${ride['seats']} seats',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ride['date'],
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Booking ride...')));
                  },
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 1) {
          // Find
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AvailableRidesScreen()),
          );
        } else if (index == 2) {
          // Offer
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OfferRideScreen()),
          );
        } else if (index == 4) {
          // Menu - Open drawer
          _scaffoldKey.currentState?.openDrawer();
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'My Rides',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Response'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),

        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryGreen),
            child: Center(
              child: Image.network(
                'https://greencar.ngo/assets/logo.jpg',
                height: 100,
                width: 100,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.directions_car,
                    color: Colors.white,
                    size: 80,
                  );
                },
              ),
            ),
          ),
          _buildDrawerItem(Icons.description_outlined, 'Terms and Conditions'),
          _buildDrawerItem(Icons.security_outlined, 'Carpool Safety Tips'),
          _buildDrawerItem(Icons.privacy_tip_outlined, 'Privacy Policy'),
          _buildDrawerItem(Icons.info_outline, 'Disclaimer'),
          _buildDrawerItem(Icons.business_outlined, 'GreenCar as CSR Project'),
          _buildDrawerItem(Icons.eco_outlined, 'ESG with GreenCar'),
          _buildDrawerItem(Icons.volunteer_activism_outlined, 'Show You Care'),
          _buildDrawerItem(Icons.handshake_outlined, 'Our Sponsors'),
          _buildDrawerItem(Icons.groups_outlined, 'About Us'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title coming soon!')));
      },
    );
  }
}
