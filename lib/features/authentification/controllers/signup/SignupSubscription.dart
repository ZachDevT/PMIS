import 'package:get/get.dart';

/// Controller for managing signup subscription state
class SignupSubscriptionController extends GetxController {
  // Tracks the current page (0: ServicePlans, 1: personal info, 2: payment)
  final RxInt currentPage = 0.obs;
  
  // Tracks the selected ServicePlan plan
  // final Rx<ServicePlan?> selectedPlan = Rx<ServicePlan?>(null);
  
  /// Navigate to next page
  void nextPage() {
    if (currentPage.value < 2) {
      currentPage.value++;
    }
  }
  
  /// Navigate to previous page
  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }
  
  /// Go to specific page
  void goToPage(int page) {
    if (page >= 0 && page <= 2) {
      currentPage.value = page;
    }
  }
  
  /// Reset to initial state
  void reset() {
    currentPage.value = 0;
    // selectedPlan.value = null;
  }
}
