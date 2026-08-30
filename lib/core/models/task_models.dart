/// Unique identifier for a task.
class TaskId {
  final String value;

  const TaskId(this.value);

  factory TaskId.generate() {
    // Will be implemented with uuid package in service layer
    throw UnimplementedError('Use TaskIdGenerator in services');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskId && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'TaskId($value)';
}

/// Represents the reminder setting for a task.
enum ReminderSetting {
  off,
  fifteenMinutes,
  twentyMinutes,
  thirtyMinutes,
  oneHour,
  twoHours,
  useDefault;

  /// Returns the duration in minutes for this setting.
  /// Returns null for [off] and [useDefault].
  int? get durationInMinutes {
    switch (this) {
      case ReminderSetting.off:
        return null;
      case ReminderSetting.fifteenMinutes:
        return 15;
      case ReminderSetting.twentyMinutes:
        return 20;
      case ReminderSetting.thirtyMinutes:
        return 30;
      case ReminderSetting.oneHour:
        return 60;
      case ReminderSetting.twoHours:
        return 120;
      case ReminderSetting.useDefault:
        return null;
    }
  }

  /// Serializes to a string for storage.
  String toJson() => name;

  /// Deserializes from a string.
  static ReminderSetting fromJson(String json) {
    return ReminderSetting.values.firstWhere(
      (e) => e.name == json,
      orElse: () => ReminderSetting.useDefault,
    );
  }
}

/// A draft of a task created by the parser.
/// This is a temporary representation before the task is saved.
class TaskDraft {
  final String title;
  final DateTime? dueDate;
  final bool hasExplicitTime;

  const TaskDraft({
    required this.title,
    this.dueDate,
    this.hasExplicitTime = false,
  });

  /// Creates a copy with updated fields.
  TaskDraft copyWith({
    String? title,
    DateTime? dueDate,
    bool? hasExplicitTime,
  }) {
    return TaskDraft(
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      hasExplicitTime: hasExplicitTime ?? this.hasExplicitTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDraft &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          _datesEqual(dueDate, other.dueDate) &&
          hasExplicitTime == other.hasExplicitTime;

  bool _datesEqual(DateTime? a, DateTime? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day &&
        a.hour == b.hour &&
        a.minute == b.minute;
  }

  @override
  int get hashCode => Object.hash(title, dueDate, hasExplicitTime);

  @override
  String toString() =>
      'TaskDraft(title: $title, dueDate: $dueDate, hasExplicitTime: $hasExplicitTime)';
}

/// A persisted task in the app.
class Task {
  final TaskId id;
  final String title;
  final DateTime? dueDate;
  final bool hasExplicitTime;
  final ReminderSetting reminderSetting;
  final bool completed;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.title,
    this.dueDate,
    this.hasExplicitTime = false,
    this.reminderSetting = ReminderSetting.useDefault,
    this.completed = false,
    required this.createdAt,
    this.completedAt,
  });

  /// Creates a task from a draft.
  factory Task.fromDraft(TaskDraft draft, TaskId id, DateTime now) {
    return Task(
      id: id,
      title: draft.title,
      dueDate: draft.dueDate,
      hasExplicitTime: draft.hasExplicitTime,
      createdAt: now,
    );
  }

  /// Marks the task as completed.
  Task markCompleted(DateTime completedAt) {
    return copyWith(
      completed: true,
      completedAt: completedAt,
    );
  }

  /// Marks the task as incomplete.
  Task markIncomplete() {
    return copyWith(
      completed: false,
      completedAt: null,
    );
  }

  /// Creates a copy with updated fields.
  Task copyWith({
    TaskId? id,
    String? title,
    DateTime? dueDate,
    bool? hasExplicitTime,
    ReminderSetting? reminderSetting,
    bool? completed,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      hasExplicitTime: hasExplicitTime ?? this.hasExplicitTime,
      reminderSetting: reminderSetting ?? this.reminderSetting,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Serializes to a JSON map for storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id.value,
      'title': title,
      'dueDate': dueDate?.toIso8601String(),
      'hasExplicitTime': hasExplicitTime,
      'reminderSetting': reminderSetting.toJson(),
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// Deserializes from a JSON map.
  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      id: TaskId(json['id'] as String),
      title: json['title'] as String,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      hasExplicitTime: json['hasExplicitTime'] as bool,
      reminderSetting:
          ReminderSetting.fromJson(json['reminderSetting'] as String),
      completed: json['completed'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          _datesEqual(dueDate, other.dueDate) &&
          hasExplicitTime == other.hasExplicitTime &&
          reminderSetting == other.reminderSetting &&
          completed == other.completed &&
          _datesEqual(createdAt, other.createdAt);

  bool _datesEqual(DateTime? a, DateTime? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a.isAtSameMomentAs(b);
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        dueDate,
        hasExplicitTime,
        reminderSetting,
        completed,
        createdAt,
        completedAt,
      );

  @override
  String toString() {
    return 'Task(id: $id, title: $title, dueDate: $dueDate, '
        'hasExplicitTime: $hasExplicitTime, reminderSetting: $reminderSetting, '
        'completed: $completed, createdAt: $createdAt, completedAt: $completedAt)';
  }
}

/// Application settings.
class AppSettings {
  final ReminderSetting defaultReminderSetting;

  const AppSettings({
    this.defaultReminderSetting = ReminderSetting.twentyMinutes,
  });

  AppSettings copyWith({
    ReminderSetting? defaultReminderSetting,
  }) {
    return AppSettings(
      defaultReminderSetting: defaultReminderSetting ?? this.defaultReminderSetting,
    );
  }

  /// Serializes to a JSON map for storage.
  Map<String, dynamic> toJson() {
    return {
      'defaultReminderSetting': defaultReminderSetting.toJson(),
    };
  }

  /// Deserializes from a JSON map.
  static AppSettings fromJson(Map<String, dynamic> json) {
    return AppSettings(
      defaultReminderSetting: ReminderSetting.fromJson(
        json['defaultReminderSetting'] as String,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          defaultReminderSetting == other.defaultReminderSetting;

  @override
  int get hashCode => defaultReminderSetting.hashCode;

  @override
  String toString() => 'AppSettings(defaultReminderSetting: $defaultReminderSetting)';
}
