Map<String, dynamic> translations = {
  "hello": "HELLO",
  "world": "world",
  "hello_world": "@.lower:hello @.capitalize:world @.upper:one.two.three {arg}",
  "test": "example",
  "test_with_arguments": "Test => {arg}",
  "uppercase_test": "{ARG}",
  "capitalize_test": "{Arg}",
  "one": {
    "two": {"three": "four"}
  },
  "day": {
    "-1": "Yesterday",
    "0": "Today",
    "1": "Tomorrow",
    "2": "2 days later",
    "3:6": "A few days later",
    "8:13": "After a week",
    "7|14|21|27": "Earlier in the week",
    "*": "Any day",
  },
  "day_with_arguments": {
    "1": "{day} day",
    "0|2:6": "{day} days",
    "7:*": "{day} after a week",
  },
  "plural": {
    "zero": "{day} zero",
    "one": "{day} one",
    "two": "{day} two",
    "few": "{day} few",
    "many": "{day} many",
    "other": "{day} other"
  },
  "plural_other": {"other": "other"}
};

Map<String, dynamic> fallbackTranslations = {
  "fallback": "Fallback",
  "test": "fallback test",
  "test_with_arguments": " fallback test => {arg}",
  "one": {
    "two": {"three": "fallback four"}
  },
  "day": {
    "-1": "fallback Yesterday",
    "0": "fallback Today",
    "1": "fallback Tomorrow",
    "2": "fallback 2 days later",
    "3:6": "fallback A few days later",
    "8:13": "fallback After a week",
    "7|14|21|27": "fallback Earlier in the week",
    "*": "fallback Any day",
  },
  "day_with_arguments": {
    "1": "fallback {day} day",
    "0|2:6": "fallback {day} days",
    "7:*": "fallback {day} after a week",
  }
};
