import 'package:easyguard/public/lang/sit_localizations.dart';

final _predefinedMessages = [
  'Your transportation has arrived.',
  'Your package has arrvied.',
  'Food delivery has arrived.',
  'Your pet service has arrived.',
  'Your health specialist has arrived.',
  'You have new message.',
  'Your guest has arrived.',
  'Your service specialist has arrived.',
  'Your visitor exceed the visit time.',
  'Your favorite has arrived.',
  'Your visitor has arrived.'
];
preDefinedMessages(i) {
  return _predefinedMessages[i];
}

visitus(context, i) {
  switch (i) {
    case 0:
      return SitLocalizations.of(context).notArrived();
      break;
    case 1:
      return SitLocalizations.of(context).arrived();
      break;
    case 2:
      return SitLocalizations.of(context).ended();
      break;
    case 3:
      return SitLocalizations.of(context).expired();
      break;
    case 4:
      return SitLocalizations.of(context).all();
      break;
    default:
      return '';
      break;
  }
}

userType(context, i) {
  switch (i) {
    case 0:
      return SitLocalizations.of(context).resident();
      break;
    case 1:
      return SitLocalizations.of(context).favorite();
      break;
    case 2:
      return SitLocalizations.of(context).serviceProvider();
      break;
    case 3:
      return SitLocalizations.of(context).visitor();
      break;
    default:
      return '';
      break;
  }
}

monthAbbr(context, i) {
  switch (i) {
    case 0:
      return SitLocalizations.of(context).jan();
      break;
    case 1:
      return SitLocalizations.of(context).feb();
      break;
    case 2:
      return SitLocalizations.of(context).mar();
      break;
    case 3:
      return SitLocalizations.of(context).apr();
      break;
    case 4:
      return SitLocalizations.of(context).may();
      break;
    case 5:
      return SitLocalizations.of(context).jun();
      break;
    case 6:
      return SitLocalizations.of(context).jul();
      break;
    case 7:
      return SitLocalizations.of(context).aug();
      break;
    case 8:
      return SitLocalizations.of(context).sep();
      break;
    case 9:
      return SitLocalizations.of(context).oct();
      break;
    case 10:
      return SitLocalizations.of(context).nov();
      break;
    case 11:
      return SitLocalizations.of(context).dec();
      break;
    default:
      return '';
      break;
  }
}

notificationType(context, i) {
  switch (i) {
    case 0:
      return SitLocalizations.of(context).transport();
      break;
    case 1:
      return SitLocalizations.of(context).parcel();
      break;
    case 2:
      return SitLocalizations.of(context).food();
      break;
    case 3:
      return SitLocalizations.of(context).pet();
      break;
    case 4:
      return SitLocalizations.of(context).health();
      break;
    case 5:
      return SitLocalizations.of(context).message();
      break;
    case 6:
      return SitLocalizations.of(context).guest();
      break;
    case 7:
      return SitLocalizations.of(context).service();
      break;
    case 8:
      return SitLocalizations.of(context).visitTimeExpired();
      break;
    case 9:
      return SitLocalizations.of(context).favorite();
      break;
    default:
      return '';
      break;
  }
}

userNotifyMsg(context, i, name) {
  return SitLocalizations.of(context).send() +
      ' ' +
      notificationType(context, i) +
      ' ' +
      SitLocalizations.of(context).notification() +
      ' ' +
      SitLocalizations.of(context).to() +
      ' $name?';
}
