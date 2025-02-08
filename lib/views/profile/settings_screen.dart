import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/dummy_data_generator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _language = 'English';
  bool _isGeneratingData = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      _language = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('dark_mode_enabled', _darkModeEnabled);
    await prefs.setString('language', _language);
  }

  Future<void> _generateDummyData() async {
    setState(() {
      _isGeneratingData = true;
    });

    try {
      final generator = DummyDataGenerator();
      await generator.generateDummyData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dummy data generated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating dummy data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingData = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            'General',
            [
              SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Receive updates about appointments and medications'),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  _saveSettings();
                },
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Use dark theme throughout the app'),
                value: _darkModeEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                  _saveSettings();
                },
              ),
            ],
          ),
          _buildSection(
            'Language',
            [
              ListTile(
                title: const Text('App Language'),
                subtitle: Text(_language),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showLanguageDialog(),
              ),
            ],
          ),
          _buildSection(
            'Security',
            [
              ListTile(
                title: const Text('Change Password'),
                leading: const Icon(Icons.lock),
                onTap: () {
                  // TODO: Implement change password
                },
              ),
              ListTile(
                title: const Text('Privacy Policy'),
                leading: const Icon(Icons.privacy_tip),
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
            ],
          ),
          _buildSection(
            'About',
            [
              ListTile(
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                title: const Text('Terms of Service'),
                onTap: () {
                  // TODO: Show terms of service
                },
              ),
              ListTile(
                title: const Text('Contact Support'),
                onTap: () {
                  // TODO: Open support contact options
                },
              ),
            ],
          ),
          if (_isGeneratingData)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            ListTile(
              title: const Text('Generate Dummy Data'),
              subtitle: const Text('Add sample data to the database'),
              leading: const Icon(Icons.data_array),
              onTap: _generateDummyData,
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Future<void> _showLanguageDialog() async {
    final languages = ['English', 'Spanish', 'French', 'German'];
    final selectedLanguage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Language'),
          children: languages.map((String language) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, language);
              },
              child: Text(language),
            );
          }).toList(),
        );
      },
    );

    if (selectedLanguage != null) {
      setState(() {
        _language = selectedLanguage;
      });
      _saveSettings();
    }
  }
}
