import 'dart:async';
import 'package:easyguard/public/i18n/messages_all.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class SitLocalizations {
  static Future<SitLocalizations> load(Locale locale) async {
    final String localeName =
        locale.countryCode == null || locale.countryCode.isEmpty
            ? locale.languageCode
            : locale.toString();

    // converting "en-US" to "en_US".
    final String canoniicalLacaleName = Intl.canonicalizedLocale(localeName);

    // Load localized messages for the current locale.
    await initializeMessages((canoniicalLacaleName));

    // Force the locale in Intl.
    Intl.defaultLocale = canoniicalLacaleName;

    return SitLocalizations();
  }

  static SitLocalizations of(BuildContext context) =>
      Localizations.of<SitLocalizations>(context, SitLocalizations);

  String get title =>
      Intl.message('EASY IN EASY OUT', name: 'title', desc: 'App title');

  String login() => Intl.message('Login', name: 'login', desc: '');
  String invalidLogin() => Intl.message('Username or password is incorrect',
      name: 'invalidLogin', desc: '');
  String multipleLogin() =>
      Intl.message('Multiple log in', name: 'multipleLogin', desc: '');
  String hintUsername() =>
      Intl.message('Username', name: 'hintUsername', desc: '');
  String hintPassword() =>
      Intl.message('Password', name: 'hintPassword', desc: '');
  String loginSuccess() =>
      Intl.message('Login successful', name: 'loginSuccess', desc: '');
  String loginFailure() =>
      Intl.message('Login failed', name: 'loginFailure', desc: '');
  String users() => Intl.message('Users', name: 'users', desc: '');
  String schedule() => Intl.message('Schedule', name: 'schedule', desc: '');
  String scan() => Intl.message('Scan', name: 'scan', desc: '');
  String search() => Intl.message('Search', name: 'search', desc: '');
  String serverError() =>
      Intl.message('Something went wrong', name: 'serverError', desc: '');
  String houseID() => Intl.message('House ID', name: 'houseID', desc: '');
  String direction() => Intl.message('Directions', name: 'direction', desc: '');
  String userLocations() =>
      Intl.message('User Locations', name: 'userLocations', desc: '');
  String transport() => Intl.message('Transport', name: 'transport', desc: '');
  String parcel() => Intl.message('Parcel', name: 'parcel', desc: '');
  String food() => Intl.message('Food', name: 'food', desc: '');
  String pet() => Intl.message('Pet', name: 'pet', desc: '');
  String health() => Intl.message('Health', name: 'health', desc: '');
  String message() => Intl.message('Message', name: 'message', desc: '');
  String guest() => Intl.message('Guest', name: 'guest', desc: '');
  String service() => Intl.message('Service', name: 'service', desc: '');
  String send() => Intl.message('Send', name: 'send', desc: '');
  String addPlate() => Intl.message('Add plate', name: 'addPlate', desc: '');
  String typeMessageHere() =>
      Intl.message('Type message here', name: 'typeMessageHere', desc: '');
  String noDirection() => Intl.message(
      'The resident did not provide extra information on how to get to his residence',
      name: 'noDirection',
      desc: '');
  String noCameras() => Intl.message(
      'The cameras on this mobile phone are not available currently.',
      name: 'noCameras',
      desc: '');
  String addGuestName() =>
      Intl.message('Add guest name', name: 'addGuestName', desc: '');
  String arrival() => Intl.message('Arrival', name: 'arrival', desc: '');
  String departure() => Intl.message('Departure', name: 'departure', desc: '');
  String resident() => Intl.message('Resident', name: 'resident', desc: '');
  String visitor() => Intl.message('Visitor', name: 'visitor', desc: '');
  String status() => Intl.message('Status', name: 'status', desc: '');
  String type() => Intl.message('Type', name: 'type', desc: '');
  String gate() => Intl.message('Gate', name: 'gate', desc: '');
  String event() => Intl.message('Event', name: 'event', desc: '');
  String retur() => Intl.message('Return', name: 'retur', desc: '');
  String visit() => Intl.message('Visit', name: 'visit', desc: '');
  String deassociate() =>
      Intl.message('Deassociate\n Plate', name: 'deassociate', desc: '');
  String extendVisit() =>
      Intl.message('Extend visit', name: 'extendVisit', desc: '');
  String confirmExtendVisit() => Intl.message('Are you sure to extend visit?',
      name: 'confirmExtendVisit', desc: '');
  String scanMode() =>
      Intl.message('Select the scan mode', name: 'scanMode', desc: '');
  String qrcode() => Intl.message('QR Code', name: 'qrcode', desc: '');
  String bio() => Intl.message('Biometric capture', name: 'bio', desc: '');
  String plate() =>
      Intl.message('Plate number capture', name: 'plate', desc: '');
  String scanning() => Intl.message('Scanning', name: 'scanning', desc: '');
  String noResidents() =>
      Intl.message('There is no resident', name: 'noResidents', desc: '');
  String visitTimeExpired() =>
      Intl.message('Visit time expired', name: 'visitTimeExpired', desc: '');
  String notifyResident() =>
      Intl.message('Notify resident', name: 'notifyResident', desc: '');
  String invalidCode() =>
      Intl.message('Invalid code', name: 'invalidCode', desc: '');
  String invalidUser() =>
      Intl.message('Invalid user', name: 'invalidUser', desc: '');
  String invalidPlate() =>
      Intl.message('Invalid plate', name: 'invalidPlate', desc: '');
  String validCode() => Intl.message('Valid code', name: 'validCode', desc: '');
  String validUser() => Intl.message('Valid user', name: 'validUser', desc: '');
  String validPlate() =>
      Intl.message('Valid plate', name: 'validPlate', desc: '');
  String language() => Intl.message('Language', name: 'language', desc: '');
  String logout() => Intl.message('Log out', name: 'logout', desc: '');
  String msgSentSuccess() => Intl.message('Message sent successfully',
      name: 'msgSentSuccess', desc: '');
  String readyPleaseTapToScan() => Intl.message('Ready, please tap to scan',
      name: 'readyPleaseTapToScan', desc: '');
  String welcome() => Intl.message('Welcome', name: 'welcome', desc: '');
  String plateAssociated() => Intl.message('Plate associated successfully',
      name: 'plateAssociated', desc: '');
  String plateDeAssociated() => Intl.message('Plate deassociated successfully',
      name: 'plateDeAssociated', desc: '');
  String plateDeAssociatedFail() => Intl.message('Plate deassociation failed',
      name: 'plateDeAssociatedFail', desc: '');
  String editProfile() =>
      Intl.message('Edit profile', name: 'editProfile', desc: '');
  String contact() => Intl.message('Contact', name: 'contact', desc: '');
  String notifications() =>
      Intl.message('Notifications', name: 'notifications', desc: '');
  String faq() => Intl.message('FAQ', name: 'faq', desc: '');
  String somethingWentWrong() => Intl.message('Something went wrong',
      name: 'somethingWentWrong', desc: '');
  String yes() => Intl.message('Yes', name: 'yes', desc: '');
  String no() => Intl.message('No', name: 'no', desc: '');
  String sendingNotification() => Intl.message('Sending notification...',
      name: 'sendingNotification', desc: '');
  String messageLengthExceed() => Intl.message(
      'Exceeded max length of the message\nPlease input less than 200 characters',
      name: 'messageLengthExceed',
      desc: '');
  String wantLogout() =>
      Intl.message('Are you sure to log out?', name: 'wantLogout', desc: '');
  String wantExit() =>
      Intl.message('Are you sure to exit?', name: 'wantExit', desc: '');
  String show() => Intl.message('Show', name: 'show', desc: '');
  String unread() => Intl.message('Unread', name: 'unread', desc: '');
  String notificationSentSuccessful() =>
      Intl.message('Notification sent successfully',
          name: 'notificationSentSuccessful', desc: '');
  String notificationSentFailure() =>
      Intl.message('Notification sending failed',
          name: 'notificationSentFailure', desc: '');

  String messageEmpty() =>
      Intl.message('Message is empty.\nPlease input message',
          name: 'messageEmpty', desc: '');
  String exitMessage() =>
      Intl.message('Double click to exit', name: 'exitMessage', desc: '');
  String refresh() => Intl.message('Refresh', name: 'refresh', desc: '');
  String clearAll() => Intl.message('Clear all', name: 'clearAll', desc: '');
  String readAll() => Intl.message('Read all', name: 'readAll', desc: '');
  String guestNameEmpty() =>
      Intl.message('Guest name is empty\nPlease input guest name',
          name: 'guestNameEmpty', desc: '');
  String guestImageEmpty() => Intl.message('Please take image of guest',
      name: 'guestImageEmpty', desc: '');
  String remove() => Intl.message('Remove', name: 'remove', desc: '');
  String neww() => Intl.message('New', name: 'neww', desc: '');
  String detail() => Intl.message('Detail', name: 'detail', desc: '');
  String noNotificationsRecent() =>
      Intl.message('There is no recent notification',
          name: 'noNotificationsRecent', desc: '');
  String noInvitations() => Intl.message('The guest has no valid invitations',
      name: 'noInvitations', desc: '');
  String noSchedule() =>
      Intl.message('There is no visit scheduled', name: 'noSchedule', desc: '');
  String succeded() =>
      Intl.message('Operation succeded', name: 'succeded', desc: '');
  String failed() => Intl.message('Operation failed', name: 'failed', desc: '');
  String passMsg() => Intl.message('Are you sure to pass this visitor?',
      name: 'passMsg', desc: '');
  String ending() => Intl.message(
      'The visitor is going out the residential\nIs he going to end visit?',
      name: 'ending',
      desc: '');

  String end() => Intl.message('End', name: 'end', desc: '');
  String endVisit() => Intl.message('End visit', name: 'endVisit', desc: '');
  String comeback() => Intl.message('Comeback', name: 'comeback', desc: '');
  String cancel() => Intl.message('Cancel', name: 'cancel', desc: '');
  String goout() => Intl.message('Go out', name: 'goout', desc: '');
  String userDetail() =>
      Intl.message('The user has been verified as the following qualifications',
          name: 'userDetail', desc: '');
  String invitations() =>
      Intl.message('Invitations', name: 'invitations', desc: '');
  String noFavorites() =>
      Intl.message('The user has not been registered as favorite',
          name: 'noFavorites', desc: '');
  String favorites() => Intl.message('Favorites', name: 'favorites', desc: '');
  String notArrived() =>
      Intl.message('Not arrived', name: 'notArrived', desc: '');
  String arrived() => Intl.message('Arrived', name: 'arrived', desc: '');
  String ended() => Intl.message('Ended', name: 'ended', desc: '');
  String expired() => Intl.message('Expired', name: 'expired', desc: '');
  String wentOut() => Intl.message('Went out', name: 'wentOut', desc: '');
  String favorite() => Intl.message('Favorite', name: 'favorite', desc: '');
  String saveChange() =>
      Intl.message('Save change', name: 'saveChange', desc: '');
  String serviceProvider() =>
      Intl.message('Service provider', name: 'serviceProvider', desc: '');
  String multipleLoginMessage() => Intl.message(
      'Detected another device logged in with this profile.\nWe will log out of this device.',
      name: 'multipleLoginMessage',
      desc: '');
  String jan() => Intl.message('JAN', name: 'jan', desc: '');
  String feb() => Intl.message('FEB', name: 'feb', desc: '');
  String mar() => Intl.message('MAR', name: 'mar', desc: '');
  String apr() => Intl.message('APR', name: 'apr', desc: '');
  String may() => Intl.message('MAY', name: 'may', desc: '');
  String jun() => Intl.message('JUN', name: 'jun', desc: '');
  String jul() => Intl.message('JUL', name: 'jul', desc: '');
  String aug() => Intl.message('AUG', name: 'aug', desc: '');
  String sep() => Intl.message('SEP', name: 'sep', desc: '');
  String oct() => Intl.message('OCT', name: 'oct', desc: '');
  String nov() => Intl.message('NOV', name: 'nov', desc: '');
  String dec() => Intl.message('DEC', name: 'dec', desc: '');
  String all() => Intl.message('All', name: 'all', desc: '');
  String plateNotAllowed() =>
      Intl.message('This residential doesn\'t allow plate.',
          name: 'plateNotAllowed', desc: '');
  String notification() =>
      Intl.message('Notification', name: 'notification', desc: '');
  String to() => Intl.message('To', name: 'to', desc: '');
  String haveNewNotifications(i) => Intl.plural(i,
      other: 'You have $i unread notifications',
      args: [i],
      name: 'haveNewNotifications',
      desc: '');
}
