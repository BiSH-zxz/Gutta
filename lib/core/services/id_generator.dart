/// Unique identifier generator for tasks.
abstract class IdGenerator {
  String generate();
}

/// Default implementation using uuid package.
class UuidIdGenerator implements IdGenerator {
  @override
  String generate() {
    // Will be implemented with actual uuid generation
    // For now, using a simple timestamp-based approach
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
