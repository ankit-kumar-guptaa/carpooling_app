import 'package:flutter/material.dart';
import '../utils/colors.dart';

class SearchScreen extends StatefulWidget {
  final bool isSource;

  const SearchScreen({Key? key, required this.isSource}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _suggestions = [];
  String _searchQuery = '';
  bool _isLoading = false;

  // Dummy data for places
  final List<Map<String, String>> _dummyPlaces = [
    {'name': 'Andheri East', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Andheri West', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Bandra East', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Bandra West', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Borivali East', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Borivali West', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Chembur', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Dadar', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Goregaon', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Juhu', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Kandivali', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Kurla', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Malad', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Powai', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Santacruz', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Vile Parle', 'address': 'Mumbai, Maharashtra'},
    {'name': 'Worli', 'address': 'Mumbai, Maharashtra'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _performSearch();
    });
  }

  void _performSearch() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(Duration(milliseconds: 300), () {
      // Filter dummy places based on search query
      final filteredPlaces = _dummyPlaces.where((place) {
        return place['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            place['address']!.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();

      setState(() {
        _suggestions = filteredPlaces;
        _isLoading = false;
      });
    });

    // In a real app, you would use the Google Places API here
    // Example:
    // final places = await GoogleMapsPlaces(apiKey: 'YOUR_API_KEY')
    //     .autocomplete(_searchQuery);
  }

  void _selectPlace(Map<String, String> place) {
    // Return selected place to previous screen
    Navigator.pop(context, place);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isSource ? 'Select pickup location' : 'Select drop location',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // Search input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Icon(
                  widget.isSource ? Icons.circle : Icons.location_on,
                  color: widget.isSource ? AppColors.primaryGreen : Colors.red,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: widget.isSource
                          ? 'Search for pickup location'
                          : 'Search for drop location',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
              ],
            ),
          ),
          Divider(height: 1),

          // Swap button (only show if navigated from home screen)
          if (Navigator.canPop(context))
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(isSource: !widget.isSource),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Row(
                  children: [
                    Icon(Icons.swap_vert, color: AppColors.primaryGreen),
                    SizedBox(width: 12),
                    Text(
                      'Swap ${widget.isSource ? 'pickup' : 'drop'} location',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Loading indicator
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                ),
              ),
            ),

          // Search results
          Expanded(
            child: _suggestions.isEmpty && _searchQuery.isNotEmpty && !_isLoading
                ? Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final place = _suggestions[index];
                      return ListTile(
                        leading: Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey[600],
                        ),
                        title: Text(place['name']!),
                        subtitle: Text(place['address']!),
                        onTap: () => _selectPlace(place),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}