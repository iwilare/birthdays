import 'dart:io';

import 'package:ical/serializer.dart';

void main(List<String> arguments) {
  stdout.write(
    (ICalendar(company: 'iwilare', product: 'birthdays', lang: 'EN')
      ..addAll(
        File(arguments.first)
          .readAsLinesSync()
          .map((s) {
            var m = RegExp(r'(?<m>.*)-(?<d>.*)-(?<y>[^ ]*) (?<name>.*)').firstMatch(s)!;
            return (y: int.tryParse(m.namedGroup('y')!) ?? "",
                    m: int.tryParse(m.namedGroup('m')!) ?? 0,
                    d: int.tryParse(m.namedGroup('d')!) ?? 0,
                    name: m.namedGroup('name')!); })
          .map((e) => IEvent(start: DateTime(DateTime.now().year, e.m, e.d),
                             summary: "Birthday - ${e.name}",
                             description: "${e.y}",
                             transparency: ITimeTransparency.TRANSPARENT,
                             rrule: IRecurrenceRule(frequency: IRecurrenceFrequency.YEARLY))
                            ).toList()))
      .serialize());
}
