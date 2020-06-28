// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "button_done" : MessageLookupByLibrary.simpleMessage("Done"),
    "content_add_flarum" : MessageLookupByLibrary.simpleMessage("Please enter a flarum site to continue:"),
    "error_url" : MessageLookupByLibrary.simpleMessage("URL Error!"),
    "subtitle_latest" : MessageLookupByLibrary.simpleMessage("Latest"),
    "subtitle_newest" : MessageLookupByLibrary.simpleMessage("Newest"),
    "subtitle_oldest" : MessageLookupByLibrary.simpleMessage("Oldest"),
    "subtitle_top" : MessageLookupByLibrary.simpleMessage("Top"),
    "title_addSite" : MessageLookupByLibrary.simpleMessage("Add Site"),
    "title_sort" : MessageLookupByLibrary.simpleMessage("Sort"),
    "title_switchSite" : MessageLookupByLibrary.simpleMessage("Switch Site"),
    "title_welcome" : MessageLookupByLibrary.simpleMessage("Welcome!")
  };
}
