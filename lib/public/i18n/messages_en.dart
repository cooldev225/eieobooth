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

  static m0(i) =>
      "${Intl.plural(i, other: 'You have ${i} unread notifications')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "addGuestName": MessageLookupByLibrary.simpleMessage("Add guest name"),
        "addPlate": MessageLookupByLibrary.simpleMessage("Add plate"),
        "apr": MessageLookupByLibrary.simpleMessage("APR"),
        "arrival": MessageLookupByLibrary.simpleMessage("Arrival"),
        "arrived": MessageLookupByLibrary.simpleMessage("Arrived"),
        "aug": MessageLookupByLibrary.simpleMessage("AUG"),
        "bio": MessageLookupByLibrary.simpleMessage("Biometric capture"),
        "clearAll": MessageLookupByLibrary.simpleMessage("Clear all"),
        "comeback": MessageLookupByLibrary.simpleMessage("Comeback"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "confirmExtendVisit": MessageLookupByLibrary.simpleMessage(
            "Are you sure to extend visit?"),
        "contact": MessageLookupByLibrary.simpleMessage("Contact"),
        "dec": MessageLookupByLibrary.simpleMessage("DEC"),
        "departure": MessageLookupByLibrary.simpleMessage("Departure"),
        "detail": MessageLookupByLibrary.simpleMessage("Detail"),
        "direction": MessageLookupByLibrary.simpleMessage("Directions"),
        "editProfile": MessageLookupByLibrary.simpleMessage("Edit profile"),
        "end": MessageLookupByLibrary.simpleMessage("End"),
        "endVisit": MessageLookupByLibrary.simpleMessage("End visit"),
        "ended": MessageLookupByLibrary.simpleMessage("Ended"),
        "ending": MessageLookupByLibrary.simpleMessage(
            "The visitor is going out the residential\nIs he going to end visit?"),
        "event": MessageLookupByLibrary.simpleMessage("Event"),
        "exitMessage":
            MessageLookupByLibrary.simpleMessage("Double click to exit"),
        "expired": MessageLookupByLibrary.simpleMessage("Expired"),
        "extendVisit": MessageLookupByLibrary.simpleMessage("Extend visit"),
        "failed": MessageLookupByLibrary.simpleMessage("Operation failed"),
        "faq": MessageLookupByLibrary.simpleMessage("FAQ"),
        "favorite": MessageLookupByLibrary.simpleMessage("Favorite"),
        "favorites": MessageLookupByLibrary.simpleMessage("Favorites"),
        "feb": MessageLookupByLibrary.simpleMessage("FEB"),
        "food": MessageLookupByLibrary.simpleMessage("Food"),
        "gate": MessageLookupByLibrary.simpleMessage("Gate"),
        "goout": MessageLookupByLibrary.simpleMessage("Go out"),
        "guest": MessageLookupByLibrary.simpleMessage("Guest"),
        "guestImageEmpty":
            MessageLookupByLibrary.simpleMessage("Please take image of guest"),
        "guestNameEmpty": MessageLookupByLibrary.simpleMessage(
            "Guest name is empty\nPlease input guest name"),
        "haveNewNotifications": m0,
        "health": MessageLookupByLibrary.simpleMessage("Health"),
        "hintPassword": MessageLookupByLibrary.simpleMessage("Password"),
        "hintUsername": MessageLookupByLibrary.simpleMessage("Username"),
        "houseID": MessageLookupByLibrary.simpleMessage("House ID"),
        "invalidCode": MessageLookupByLibrary.simpleMessage("Invalid code"),
        "invalidLogin": MessageLookupByLibrary.simpleMessage(
            "Username or password is incorrect"),
        "invalidPlate": MessageLookupByLibrary.simpleMessage("Invalid plate"),
        "invalidUser": MessageLookupByLibrary.simpleMessage("Invalid user"),
        "invitations": MessageLookupByLibrary.simpleMessage("Invitations"),
        "jan": MessageLookupByLibrary.simpleMessage("JAN"),
        "jul": MessageLookupByLibrary.simpleMessage("JUL"),
        "jun": MessageLookupByLibrary.simpleMessage("JUN"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loginFailure": MessageLookupByLibrary.simpleMessage("Login failed"),
        "loginSuccess":
            MessageLookupByLibrary.simpleMessage("Login successful"),
        "logout": MessageLookupByLibrary.simpleMessage("Log out"),
        "mar": MessageLookupByLibrary.simpleMessage("MAR"),
        "may": MessageLookupByLibrary.simpleMessage("MAY"),
        "message": MessageLookupByLibrary.simpleMessage("Message"),
        "messageEmpty": MessageLookupByLibrary.simpleMessage(
            "Message is empty.\nPlease input message"),
        "messageLengthExceed": MessageLookupByLibrary.simpleMessage(
            "Exceeded max length of the message\nPlease input less than 200 characters"),
        "msgSentSuccess":
            MessageLookupByLibrary.simpleMessage("Message sent successfully"),
        "multipleLogin":
            MessageLookupByLibrary.simpleMessage("Multiple log in"),
        "neww": MessageLookupByLibrary.simpleMessage("New"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noCameras": MessageLookupByLibrary.simpleMessage(
            "The cameras on this mobile phone are not available currently."),
        "noDirection": MessageLookupByLibrary.simpleMessage(
            "The resident did not provide extra information on how to get to his residence"),
        "noFavorites": MessageLookupByLibrary.simpleMessage(
            "The user has not been registered as favorite"),
        "noInvitations": MessageLookupByLibrary.simpleMessage(
            "The guest has no valid invitations"),
        "noNotificationsRecent": MessageLookupByLibrary.simpleMessage(
            "There is no recent notification"),
        "noResidents":
            MessageLookupByLibrary.simpleMessage("There is no resident"),
        "noSchedule":
            MessageLookupByLibrary.simpleMessage("There is no visit scheduled"),
        "notArrived": MessageLookupByLibrary.simpleMessage("Not arrived"),
        "notification": MessageLookupByLibrary.simpleMessage("Notification"),
        "notificationSentFailure":
            MessageLookupByLibrary.simpleMessage("Notification sending failed"),
        "notificationSentSuccessful": MessageLookupByLibrary.simpleMessage(
            "Notification sent successfully"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "notifyResident":
            MessageLookupByLibrary.simpleMessage("Notify resident"),
        "nov": MessageLookupByLibrary.simpleMessage("NOV"),
        "oct": MessageLookupByLibrary.simpleMessage("OCT"),
        "parcel": MessageLookupByLibrary.simpleMessage("Parcel"),
        "passMsg": MessageLookupByLibrary.simpleMessage(
            "Are you sure to pass this visitor?"),
        "pet": MessageLookupByLibrary.simpleMessage("Pet"),
        "plate": MessageLookupByLibrary.simpleMessage("Plate number capture"),
        "plateAssociated": MessageLookupByLibrary.simpleMessage(
            "Plate associated successfully"),
        "plateDeAssociated": MessageLookupByLibrary.simpleMessage(
            "Plate deassociated successfully"),
        "plateDeAssociatedFail":
            MessageLookupByLibrary.simpleMessage("Plate deassociation failed"),
        "qrcode": MessageLookupByLibrary.simpleMessage("QR Code"),
        "readAll": MessageLookupByLibrary.simpleMessage("Read all"),
        "readyPleaseTapToScan":
            MessageLookupByLibrary.simpleMessage("Ready, please tap to scan"),
        "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
        "remove": MessageLookupByLibrary.simpleMessage("Remove"),
        "resident": MessageLookupByLibrary.simpleMessage("Resident"),
        "retur": MessageLookupByLibrary.simpleMessage("Return"),
        "scan": MessageLookupByLibrary.simpleMessage("Scan"),
        "scanMode":
            MessageLookupByLibrary.simpleMessage("Select the scan mode"),
        "scanning": MessageLookupByLibrary.simpleMessage("Scanning"),
        "schedule": MessageLookupByLibrary.simpleMessage("Schedule"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "sendingNotification":
            MessageLookupByLibrary.simpleMessage("Sending notification..."),
        "sep": MessageLookupByLibrary.simpleMessage("SEP"),
        "serverError":
            MessageLookupByLibrary.simpleMessage("Something went wrong"),
        "service": MessageLookupByLibrary.simpleMessage("Service"),
        "serviceProvider":
            MessageLookupByLibrary.simpleMessage("Service provider"),
        "show": MessageLookupByLibrary.simpleMessage("Show"),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Something went wrong"),
        "status": MessageLookupByLibrary.simpleMessage("Status"),
        "succeded": MessageLookupByLibrary.simpleMessage("Operation succeded"),
        "title": MessageLookupByLibrary.simpleMessage("EASY IN EASY OUT"),
        "to": MessageLookupByLibrary.simpleMessage("To"),
        "transport": MessageLookupByLibrary.simpleMessage("Transport"),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "typeMessageHere":
            MessageLookupByLibrary.simpleMessage("Type message here"),
        "unread": MessageLookupByLibrary.simpleMessage("Unread"),
        "userDetail": MessageLookupByLibrary.simpleMessage(
            "The user has been verified as the following qualifications"),
        "userLocations": MessageLookupByLibrary.simpleMessage("User Locations"),
        "users": MessageLookupByLibrary.simpleMessage("Users"),
        "validCode": MessageLookupByLibrary.simpleMessage("Valid code"),
        "validPlate": MessageLookupByLibrary.simpleMessage("Valid plate"),
        "validUser": MessageLookupByLibrary.simpleMessage("Valid user"),
        "visit": MessageLookupByLibrary.simpleMessage("Visit"),
        "visitTimeExpired":
            MessageLookupByLibrary.simpleMessage("Visit time expired"),
        "visitor": MessageLookupByLibrary.simpleMessage("Visitor"),
        "wantExit":
            MessageLookupByLibrary.simpleMessage("Are you sure to exit?"),
        "wantLogout":
            MessageLookupByLibrary.simpleMessage("Are you sure to log out?"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
        "wentOut": MessageLookupByLibrary.simpleMessage("Went out"),
        "saveChange": MessageLookupByLibrary.simpleMessage("Save change"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "deassociate":
            MessageLookupByLibrary.simpleMessage("Deassociate\nPlate"),
        "multipleLoginMessage": MessageLookupByLibrary.simpleMessage(
            "Detected another device logged in with this profile.\nWe will log out of this device."),
        'plateNotAllowed': MessageLookupByLibrary.simpleMessage(
            'This residential doesn\'t allow plate.')
      };
}
