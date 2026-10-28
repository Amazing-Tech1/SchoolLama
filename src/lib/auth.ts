export const roleDashboardMap = {
  admin: "/admin",
  teacher: "/teacher",
  student: "/student",
  parent: "/parent",
} as const;

export type UserRole = keyof typeof roleDashboardMap;

export function isUserRole(role: unknown): role is UserRole {
  return typeof role === "string" && Object.prototype.hasOwnProperty.call(roleDashboardMap, role);
}

export function getDashboardRoute(role: unknown): string | null {
  return isUserRole(role) ? roleDashboardMap[role] : null;
}
