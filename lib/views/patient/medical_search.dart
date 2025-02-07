class MedicalSearchScreen extends StatefulWidget {
  @override
  _MedicalSearchScreenState createState() => _MedicalSearchScreenState();
}

class _MedicalSearchScreenState extends State<MedicalSearchScreen> {
  String searchQuery = '';
  String filterType = 'All';
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search medical records...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                FilterChip(
                  label: Text('All'),
                  selected: filterType == 'All',
                  onSelected: (selected) {
                    setState(() => filterType = 'All');
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Visits'),
                  selected: filterType == 'Visits',
                  onSelected: (selected) {
                    setState(() => filterType = 'Visits');
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Medications'),
                  selected: filterType == 'Medications',
                  onSelected: (selected) {
                    setState(() => filterType = 'Medications');
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Tests'),
                  selected: filterType == 'Tests',
                  onSelected: (selected) {
                    setState(() => filterType = 'Tests');
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Injections'),
                  selected: filterType == 'Injections',
                  onSelected: (selected) {
                    setState(() => filterType = 'Injections');
                  },
                ),
              ],
            ),
          ),
          
          // Date range if selected
          if (startDate != null && endDate != null)
            Padding(
              padding: EdgeInsets.all(8),
              child: Chip(
                label: Text(
                  '${startDate.toString().split(' ')[0]} to ${endDate.toString().split(' ')[0]}',
                ),
                onDeleted: () {
                  setState(() {
                    startDate = null;
                    endDate = null;
                  });
                },
              ),
            ),

          // Search results
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with filtered results count
              itemBuilder: (context, index) {
                return _buildSearchResult(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResult(int index) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(_getIconForType(filterType)),
        title: Text(_getTitleForType(filterType, index)),
        subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index * 3)).toString().split(' ')[0]}'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () => _showDetailDialog(context, index),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Visits':
        return Icons.person;
      case 'Medications':
        return Icons.medication;
      case 'Tests':
        return Icons.science;
      case 'Injections':
        return Icons.healing;
      default:
        return Icons.medical_services;
    }
  }

  String _getTitleForType(String type, int index) {
    switch (type) {
      case 'Visits':
        return 'Visit #${index + 1}';
      case 'Medications':
        return 'Medication ${index + 1}';
      case 'Tests':
        return 'Test #${index + 1}';
      case 'Injections':
        return 'Injection ${index + 1}';
      default:
        return 'Record #${index + 1}';
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Records'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Date Range'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTimeRange? range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (range != null) {
                  setState(() {
                    startDate = range.start;
                    endDate = range.end;
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getTitleForType(filterType, index)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${DateTime.now().subtract(Duration(days: index * 3)).toString().split(' ')[0]}'),
            Text('Provider: ${index % 2 == 0 ? 'Dr. Smith' : 'Nurse Emma'}'),
            Text('Location: ${index % 2 == 0 ? 'Clinic' : 'Home Visit'}'),
            Text('Notes: Regular checkup, all normal'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
} 