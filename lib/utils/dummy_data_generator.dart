class DummyDataGenerator {
    // Example method to generate dummy data
    List<String> getDummyData() {
        return ['Data 1', 'Data 2', 'Data 3'];
    }

    // New method to generate dummy data asynchronously
    Future<List<String>> generateDummyData() async {
        // Simulate a delay for async operation
        await Future.delayed(Duration(seconds: 1));
        return getDummyData();
    }
}
