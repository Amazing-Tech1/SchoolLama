export function serialize<T>(value: T): T {
  if (value == null || typeof value !== "object") {
    return value;
  }

  if (value instanceof Date) {
    return value.toISOString() as T;
  }

  if (Array.isArray(value)) {
    return value.map(serialize) as T;
  }

  // Handle Temporal objects before traversing object properties.
  const item = value as Record<string, unknown>;
  const constructorName = Object.getPrototypeOf(value)?.constructor?.name;

  if (constructorName?.startsWith("Instant") || constructorName?.startsWith("Temporal.")) {
    return String(value) as T;
  }

  const result: Record<string, unknown> = {};

  for (const [key, nestedValue] of Object.entries(item)) {
    result[key] = serialize(nestedValue);
  }

  return result as T;
}
