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

  /// `Details`
  String get title_discussion_detail {
    return Intl.message(
      'Details',
      name: 'title_discussion_detail',
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

  /// `User Info`
  String get title_user_info {
    return Intl.message(
      'User Info',
      name: 'title_user_info',
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

  /// `Search All`
  String get title_search_all {
    return Intl.message(
      'Search All',
      name: 'title_search_all',
      desc: '',
      args: [],
    );
  }

  /// `Search With `
  String get title_search_with {
    return Intl.message(
      'Search With ',
      name: 'title_search_with',
      desc: '',
      args: [],
    );
  }

  /// `Me`
  String get title_me {
    return Intl.message(
      'Me',
      name: 'title_me',
      desc: '',
      args: [],
    );
  }

  /// `Email Or UserName`
  String get title_email_or_username {
    return Intl.message(
      'Email Or UserName',
      name: 'title_email_or_username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get title_password {
    return Intl.message(
      'Password',
      name: 'title_password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get title_login {
    return Intl.message(
      'Login',
      name: 'title_login',
      desc: '',
      args: [],
    );
  }

  /// `SingUp`
  String get title_singUp {
    return Intl.message(
      'SingUp',
      name: 'title_singUp',
      desc: '',
      args: [],
    );
  }

  /// `Search With Tag`
  String get title_search_with_tag {
    return Intl.message(
      'Search With Tag',
      name: 'title_search_with_tag',
      desc: '',
      args: [],
    );
  }

  /// `Before`
  String get title_change_before {
    return Intl.message(
      'Before',
      name: 'title_change_before',
      desc: '',
      args: [],
    );
  }

  /// `After`
  String get title_change_after {
    return Intl.message(
      'After',
      name: 'title_change_after',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get title_time {
    return Intl.message(
      'Time',
      name: 'title_time',
      desc: '',
      args: [],
    );
  }

  /// `Count`
  String get title_count {
    return Intl.message(
      'Count',
      name: 'title_count',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title_title {
    return Intl.message(
      'Title',
      name: 'title_title',
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

  /// `Stickied the discussion.`
  String get c_stickied_the_discussion {
    return Intl.message(
      'Stickied the discussion.',
      name: 'c_stickied_the_discussion',
      desc: '',
      args: [],
    );
  }

  /// `Unstickied the discussion.`
  String get c_unstickied_the_discussion {
    return Intl.message(
      'Unstickied the discussion.',
      name: 'c_unstickied_the_discussion',
      desc: '',
      args: [],
    );
  }

  /// `Locked the discussion.`
  String get c_locked_the_discussion {
    return Intl.message(
      'Locked the discussion.',
      name: 'c_locked_the_discussion',
      desc: '',
      args: [],
    );
  }

  /// `Unlocked the discussion.`
  String get c_unlocked_the_discussion {
    return Intl.message(
      'Unlocked the discussion.',
      name: 'c_unlocked_the_discussion',
      desc: '',
      args: [],
    );
  }

  /// `Change the title.`
  String get c_change_the_title {
    return Intl.message(
      'Change the title.',
      name: 'c_change_the_title',
      desc: '',
      args: [],
    );
  }

  /// `Change the tag.`
  String get c_change_the_tag {
    return Intl.message(
      'Change the tag.',
      name: 'c_change_the_tag',
      desc: '',
      args: [],
    );
  }

  /// `Split post to`
  String get c_split_post_to {
    return Intl.message(
      'Split post to',
      name: 'c_split_post_to',
      desc: '',
      args: [],
    );
  }

  /// `Split post form`
  String get c_split_post_form {
    return Intl.message(
      'Split post form',
      name: 'c_split_post_form',
      desc: '',
      args: [],
    );
  }

  /// `Merged post from`
  String get c_merged_post_from {
    return Intl.message(
      'Merged post from',
      name: 'c_merged_post_from',
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