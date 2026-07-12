/// Role Manager Utility
/// Manages user roles and permissions
class RoleManager {
  // Admin role ID
  static const String superAdminRoleId = '39597d07-dcca-487c-a575-41cab031d84b';
  
  // All role IDs for reference
  static const Map<String, String> roleIds = {
    'projectManager': '0795dd0e-d0b4-4a38-a0eb-a8be935aadd3',
    'director': '1df865da-0121-4bd6-a14c-85a1e0eec3be',
    'directorDcs': '1e85a7f9-94a9-482c-b38f-3f37a7d399a6',
    'meOfficer': '266aaab5-acce-47e3-96ab-f9ddd979f49e',
    'headOfDepartment': '2a56415c-5675-4399-8af0-6339dc08fc0e',
    'superAdmin': '39597d07-dcca-487c-a575-41cab031d84b',
    'regionalManager': '3f2002ad-3ec7-411d-abc8-92dda67a184c',
    'rmo': '5af7b1a9-5366-4b6a-acbd-b708f987068d',
    'headOfRegion': '73d1729c-c46e-4beb-9b1d-f1b9dabdb560',
    'headBpd': 'a96101ec-8028-41cd-93df-49f61f0eaca6',
  };

  /// Check if a role ID is an admin role
  static bool isAdminRole(String? roleId) {
    if (roleId == null || roleId.isEmpty) return false;
    return roleId == superAdminRoleId;
  }

  /// Get role name from role ID
  static String getRoleName(String? roleId) {
    if (roleId == null || roleId.isEmpty) return 'Unknown';
    
    switch (roleId) {
      case '0795dd0e-d0b4-4a38-a0eb-a8be935aadd3':
        return 'Project Manager';
      case '1df865da-0121-4bd6-a14c-85a1e0eec3be':
        return 'Director';
      case '1e85a7f9-94a9-482c-b38f-3f37a7d399a6':
        return 'Director (DCS)';
      case '266aaab5-acce-47e3-96ab-f9ddd979f49e':
        return 'M&E Officer';
      case '2a56415c-5675-4399-8af0-6339dc08fc0e':
        return 'Head of Department';
      case '39597d07-dcca-487c-a575-41cab031d84b':
        return 'SuperAdmin';
      case '3f2002ad-3ec7-411d-abc8-92dda67a184c':
        return 'Regional Manager';
      case '5af7b1a9-5366-4b6a-acbd-b708f987068d':
        return 'RMO';
      case '73d1729c-c46e-4beb-9b1d-f1b9dabdb560':
        return 'Head of Region';
      case 'a96101ec-8028-41cd-93df-49f61f0eaca6':
        return 'Head BPD';
      default:
        return 'Unknown';
    }
  }
}

