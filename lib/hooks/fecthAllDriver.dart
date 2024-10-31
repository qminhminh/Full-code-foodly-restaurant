// ignore_for_file: unused_import, file_names

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_restaurant/models/environment.dart';
import 'package:foodly_restaurant/models/hook_models/hook_result.dart';
import 'package:foodly_restaurant/models/user.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchAllDriver() {
  final drivers = useState<List<User>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final response = await http.get(
          Uri.parse('${Environment.appBaseUrl}/api/driver/get-all-drivers'));

      if (response.statusCode == 200) {
        drivers.value = driversFromJson(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      error.value = e as Exception?;
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  // Return values
  return FetchHook(
    data: drivers.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
