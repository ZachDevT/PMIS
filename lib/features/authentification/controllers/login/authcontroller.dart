import 'package:get/get.dart';
import 'package:pmis/data/repositories/LoginRepository/LoginRepository.dart';
import 'package:pmis/navigationbar.dart';
import 'package:pmis/utils/states/app_state.dart';
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'package:pmis/utils/local_storage/storage_utility.dart';
import 'package:pmis/features/authentification/screens/login/LoginSlider.dart';
import 'package:pmis/utils/popups/loaders.dart';
import 'package:pmis/bindings/generalbindings.dart';
import 'package:pmis/features/pmis/css/controllers/CssController.dart';
import 'package:pmis/utils/helpers/role_manager.dart';

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

      // Accept any non-empty response from server - no strict validation
      if (result.isEmpty) {
        throw const ServerException('Empty response from server');
      }

      // Log the response for debugging but don't validate fields
      print('=== LOGIN RESPONSE DEBUG ===');
      print('Response keys: ${result.keys.toList()}');
      print('Full response data: $result');
      print('Response as JSON string: ${result.toString()}');
      
      // Log specific fields we're looking for
      if (result.containsKey('name')) print('name: ${result['name']}');
      if (result.containsKey('username')) print('username: ${result['username']}');
      if (result.containsKey('userName')) print('userName: ${result['userName']}');
      if (result.containsKey('fullName')) print('fullName: ${result['fullName']}');
      if (result.containsKey('displayName')) print('displayName: ${result['displayName']}');
      if (result.containsKey('email')) print('email: ${result['email']}');
      if (result.containsKey('Email')) print('Email: ${result['Email']}');
      if (result.containsKey('id')) print('id: ${result['id']}');
      if (result.containsKey('Id')) print('Id: ${result['Id']}');
      if (result.containsKey('userId')) print('userId: ${result['userId']}');
      if (result.containsKey('UserId')) print('UserId: ${result['UserId']}');
      if (result.containsKey('roleId')) print('roleId: ${result['roleId']}');
      if (result.containsKey('RoleId')) print('RoleId: ${result['RoleId']}');
      if (result.containsKey('roles')) print('roles: ${result['roles']}');
      if (result.containsKey('Roles')) print('Roles: ${result['Roles']}');
      if (result.containsKey('roleManager')) print('roleManager: ${result['roleManager']}');
      if (result.containsKey('RoleManager')) print('RoleManager: ${result['RoleManager']}');
      print('=== END LOGIN RESPONSE DEBUG ===');

      // If API doesn't return user data (only message), add username to the response
      // This handles the case where API only returns {"message":"Login Successfull"}
      final Map<String, dynamic> userData = Map<String, dynamic>.from(result);
      if (!userData.containsKey('username') && !userData.containsKey('userName') && 
          !userData.containsKey('name') && !userData.containsKey('displayName')) {
        // API doesn't return user data, so use the username from login form
        userData['username'] = username.value;
        userData['userName'] = username.value;
        print('=== API did not return user data, using username: ${username.value} ===');
      }

      // Store user data
      await _storage.saveData('user_data', userData);

      // Update state
      user.value = userData;
      loginState.value = AppState.success(userData);

      // Ensure all controllers are registered before navigation
      if (!Get.isRegistered<CssController>()) {
        GeneralBindings().dependencies();
      }
      
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
      _handleError('Unexpected Error',
          'An unexpected error occurred. Please try again.');
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
    Loaders.errorSnackbar(
      title: 'Error',
      message: message,
      duration: 4,
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

      // Navigate to login screen - NavigationMenu will ensure controllers are registered on next login
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

    // Try various field names (case-sensitive and case-insensitive)
    // Priority: name > fullName > displayName > username > email
    final displayName = userData['name']?.toString() ??
        userData['Name']?.toString() ??
        userData['fullName']?.toString() ??
        userData['FullName']?.toString() ??
        userData['displayName']?.toString() ??
        userData['DisplayName']?.toString() ??
        (userData['firstName'] != null && userData['lastName'] != null 
            ? '${userData['firstName']} ${userData['lastName']}' 
            : null) ??
        (userData['FirstName'] != null && userData['LastName'] != null 
            ? '${userData['FirstName']} ${userData['LastName']}' 
            : null) ??
        userData['username']?.toString() ??
        userData['userName']?.toString() ??
        userData['UserName']?.toString() ??
        userData['email']?.toString() ??
        userData['Email']?.toString();
    
    // If still no name found, return 'User' instead of null
    return displayName ?? 'User';
  }

  /// Get user email
  String get userEmail {
    final userData = user.value;
    if (userData == null) return '';

    return userData['email'] ??
        userData['Email'] ??
        userData['username'] ??
        userData['userName'] ??
        '';
  }

  /// Get user ID
  String get userId {
    final userData = user.value;
    if (userData == null) return '';

    return userData['id']?.toString() ??
        userData['Id']?.toString() ??
        userData['userId']?.toString() ??
        userData['UserId']?.toString() ??
        userData['user_id']?.toString() ??
        '';
  }

  /// Get user role IDs (handles both single role and array of roles)
  List<String> get userRoleIds {
    final userData = user.value;
    if (userData == null) return [];

    // Try to get roles as array
    if (userData['roles'] != null) {
      if (userData['roles'] is List) {
        return (userData['roles'] as List)
            .map((r) => r.toString())
            .where((r) => r.isNotEmpty)
            .toList();
      }
    }
    if (userData['Roles'] != null) {
      if (userData['Roles'] is List) {
        return (userData['Roles'] as List)
            .map((r) => r.toString())
            .where((r) => r.isNotEmpty)
            .toList();
      }
    }

    // Try to get single role ID
    final singleRoleId = userData['roleId'] ??
        userData['RoleId'] ??
        userData['role_id'] ??
        userData['rolemanager'] ??
        userData['roleManager'] ??
        userData['RoleManager'];
    
    if (singleRoleId != null) {
      return [singleRoleId.toString()];
    }

    return [];
  }

  /// Get user role ID (returns first role for backward compatibility)
  String? get userRoleId {
    final roleIds = userRoleIds;
    return roleIds.isNotEmpty ? roleIds.first : null;
  }

  /// Get user role names (handles multiple roles)
  String get userRoleName {
    final roleIds = userRoleIds;
    if (roleIds.isEmpty) return 'Unknown';
    
    final roleNames = roleIds
        .map((roleId) => RoleManager.getRoleName(roleId))
        .where((name) => name != 'Unknown')
        .toList();
    
    return roleNames.isEmpty 
        ? 'Unknown' 
        : roleNames.join(', ');
  }

  /// Check if current user is admin (checks all roles)
  bool get isAdmin {
    final roleIds = userRoleIds;
    if (roleIds.isEmpty) return false;
    
    // Check if any role is admin
    return roleIds.any((roleId) => RoleManager.isAdminRole(roleId));
  }
}
