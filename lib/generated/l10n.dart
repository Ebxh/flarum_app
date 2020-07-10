// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome!`
  String get title_welcome {
    return Intl.message(
      'Welcome!',
      name: 'title_welcome',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a flarum site to continue:`
  String get content_add_flarum {
    return Intl.message(
      'Please enter a flarum site to continue:',
      name: 'content_add_flarum',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get button_done {
    return Intl.message(
      'Done',
      name: 'button_done',
      desc: '',
      args: [],
    );
  }

  /// `URL Error!`
  String get error_url {
    return Intl.message(
      'URL Error!',
      name: 'error_url',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get title_home {
    return Intl.message(
      'Home',
      name: 'title_home',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get title_tags {
    return Intl.message(
      'Tags',
      name: 'title_tags',
      desc: '',
      args: [],
    );
  }

  /// `NewPost`
  String get title_new_post {
    return Intl.message(
      'NewPost',
      name: 'title_new_post',
      desc: '',
      args: [],
    );
  }

  /// `Switch Site`
  String get title_switchSite {
    return Intl.message(
      'Switch Site',
      name: 'title_switchSite',
      desc: '',
      args: [],
    );
  }

  /// `Add Site`
  String get title_addSite {
    return Intl.message(
      'Add Site',
      name: 'title_addSite',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get title_sort {
    return Intl.message(
      'Sort',
      name: 'title_sort',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get title_details {
    return Intl.message(
      'Details',
      name: 'title_details',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get title_close {
    return Intl.message(
      'Close',
      name: 'title_close',
      desc: '',
      args: [],
    );
  }

  /// `Show Details`
  String get title_show_details {
    return Intl.message(
      'Show Details',
      name: 'title_show_details',
      desc: '',
      args: [],
    );
  }

  /// `Latest`
  String get subtitle_latest {
    return Intl.message(
      'Latest',
      name: 'subtitle_latest',
      desc: '',
      args: [],
    );
  }

  /// `Top`
  String get subtitle_top {
    return Intl.message(
      'Top',
      name: 'subtitle_top',
      desc: '',
      args: [],
    );
  }

  /// `Newest`
  String get subtitle_newest {
    return Intl.message(
      'Newest',
      name: 'subtitle_newest',
      desc: '',
      args: [],
    );
  }

  /// `Oldest`
  String get subtitle_oldest {
    return Intl.message(
      'Oldest',
      name: 'subtitle_oldest',
      desc: '',
      args: [],
    );
  }

  /// `stickied the discussion.`
  String get c_stickied_the_discussion {
    return Intl.message(
      'stickied the discussion.',
      name: 'c_stickied_the_discussion',
      desc: '',
      args: [],
    );
  }

  /// `unstickied the discussion.`
  String get c_unstickied_the_discussion {
    return Intl.message(
      'unstickied the discussion.',
      name: 'c_unstickied_the_discussion',
      desc: '',
      args: [],
    );
  }

  /// `locked the discussion.`
  String get c_locked_the_discussion {
    return Intl.message(
      'locked the discussion.',
      name: 'c_locked_the_discussion',
      desc: '',
      args: [],
    );
  }

  /// `unlocked the discussion.`
  String get c_unlocked_the_discussion {
    return Intl.message(
      'unlocked the discussion.',
      name: 'c_unlocked_the_discussion',
      desc: '',
      args: [],
    );
  }

  /// `added`
  String get c_tag_added {
    return Intl.message(
      'added',
      name: 'c_tag_added',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get c_tag_and {
    return Intl.message(
      'and',
      name: 'c_tag_and',
      desc: '',
      args: [],
    );
  }

  /// `removed`
  String get c_tag_removed {
    return Intl.message(
      'removed',
      name: 'c_tag_removed',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}