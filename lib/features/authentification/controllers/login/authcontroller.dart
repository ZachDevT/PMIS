import 'package:get/get.dart';
import 'package:pmis/data/repositories/LoginRepository/LoginRepository.dart';
import 'package:pmis/navigationbar.dart';
import 'package:pmis/utils/states/app_state.dart';
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'package:pmis/utils/local_storage/storage_utility.dart';
import 'package:pmis/features/authentification/screens/login/LoginSlider.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();
  final TLocalStorage _storage = TLocalStorage();

  // State management using AppState
  final Rx<AppState<Map<String, dynamic>>> loginState = 
      Rx<AppState<Map<String, dynamic>>>(AppState.initial());

  // Reactive state for UI
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Map<String, dynamic>?> user = Rx<Map<String, dynamic>?>(null);

  // Form controllers
  final RxString username = ''.obs;
  final RxString password = ''.obs;

  // Validation
  final RxBool isUsernameValid = false.obs;
  final RxBool isPasswordValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStoredUser();
    _setupValidation();
  }

  @override
  void onReady() {
    super.onReady();
    // Ensure user state is properly initialized
    _loadStoredUser();
  }

  /// Load stored user data if available
  void _loadStoredUser() {
    final storedUser = _storage.readData<Map<String, dynamic>>('user_data');
    if (storedUser != null) {
      user.value = storedUser;
      loginState.value = AppState.success(storedUser);
    }
  }

  /// Setup form validation
  void _setupValidation() {
    ever(username, (String value) {
      isUsernameValid.value = value.trim().isNotEmpty;
    });
    
    ever(password, (String value) {
      isPasswordValid.value = value.trim().isNotEmpty;
    });
  }

  /// Check if form is valid
  bool get isFormValid => isUsernameValid.value && isPasswordValid.value;

  /// Login method with proper state management
  Future<void> login() async {
    if (!isFormValid) {
      _showError('Please fill in all required fields');
      return;
    }

    try {
      // Set loading state
      loginState.value = AppState.loading();
      isLoading.value = true;
      errorMessage.value = '';

      // Perform login
      final result = await _repo.login(username.value, password.value);
      
      // Store user data
      await _storage.saveData('user_data', result);
      
      // Update state
      user.value = result;
      loginState.value = AppState.success(result);
      
      // Navigate to dashboard
      Get.off(() => const NavigationMenu());
      
    } on ValidationException catch (e) {
      _handleError('Validation Error', e.message);
    } on AuthException catch (e) {
      _handleError('Authentication Error', e.message);
    } on NetworkException catch (e) {
      _handleError('Network Error', e.message);
    } on ServerException catch (e) {
      _handleError('Server Error', e.message);
    } on TimeoutException catch (e) {
      _handleError('Timeout Error', e.message);
    } catch (e) {
      _handleError('Unexpected Error', 'An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle errors with proper state management
  void _handleError(String title, String message) {
    errorMessage.value = message;
    loginState.value = AppState.errorState(message);
    _showError(message);
  }

  /// Show error message to user
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 4),
    );
  }

  /// Clear error state
  void clearError() {
    errorMessage.value = '';
    if (loginState.value.hasError) {
      loginState.value = AppState.initial();
    }
  }

  /// Update username
  void updateUsername(String value) {
    username.value = value;
  }

  /// Update password
  void updatePassword(String value) {
    password.value = value;
  }

  /// Logout method
  Future<void> logout() async {
    try {
      // Clear stored data
      await _storage.removeData('user_data');
      
      // Reset state
      user.value = null;
      loginState.value = AppState.initial();
      username.value = '';
      password.value = '';
      
      // Navigate to login screen
      Get.offAll(() => const LoginSliderScreen());
      
    } catch (e) {
      _showError('Error during logout. Please try again.');
    }
  }

  /// Check if user is logged in
  bool get isLoggedIn => user.value != null;

  /// Check authentication status from storage
  bool checkAuthStatus() {
    final storedUser = _storage.readData<Map<String, dynamic>>('user_data');
    if (storedUser != null) {
      user.value = storedUser;
      loginState.value = AppState.success(storedUser);
      return true;
    }
    return false;
  }

  /// Get user display name
  String get userDisplayName {
    final userData = user.value;
    if (userData == null) return 'Guest';
    
    return userData['name'] ?? 
           userData['username'] ?? 
           userData['email'] ?? 
           'User';
  }
}
