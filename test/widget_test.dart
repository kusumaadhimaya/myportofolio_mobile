import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void useMobileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetViewInsets);
}

Future<void> openExperienceFromHome(WidgetTester tester) async {
  final experienceCard = find.text('Add Experience').first;
  await tester.ensureVisible(experienceCard);
  await tester.tap(experienceCard);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'homepage action opens the Experience form and Back returns home',
    (tester) async {
      useMobileViewport(tester);
      await tester.pumpWidget(const MyApp());

      await openExperienceFromHome(tester);
      expect(find.text('Start date'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
    },
  );

  testWidgets('drawer opens the Experience form and Home returns to homepage', (
    tester,
  ) async {
    useMobileViewport(tester);
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Experience').last);
    await tester.pumpAndSettle();
    expect(find.text('Start date'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
  });

  testWidgets('Experience form displays errors for missing required fields', (
    tester,
  ) async {
    useMobileViewport(tester);
    await tester.pumpWidget(const MyApp());
    await openExperienceFromHome(tester);

    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    await tester.pumpAndSettle();
    final saveButton = find.text('Save');
    await tester.ensureVisible(saveButton);
    expect(tester.getRect(saveButton).bottom, lessThanOrEqualTo(524));
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Title cannot be empty.'), findsOneWidget);
    expect(find.text('Description cannot be empty.'), findsOneWidget);
    expect(find.text('Choose a start date.'), findsOneWidget);
    expect(find.text('Experience berhasil ditambahkan!'), findsNothing);
  });

  testWidgets('valid Experience form shows every value in a summary dialog', (
    tester,
  ) async {
    useMobileViewport(tester);
    await tester.pumpWidget(const MyApp());
    await openExperienceFromHome(tester);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Teaching Assistant',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Supported students in the PBP course.',
    );

    final startDateField = find.byType(TextFormField).at(2);
    await tester.ensureVisible(startDateField);
    await tester.tap(startDateField);
    await tester.pumpAndSettle();

    final today = DateTime.now().day.toString();
    await tester.tap(find.text(today).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Experience berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Judul: Teaching Assistant'), findsOneWidget);
    expect(
      find.text('Deskripsi: Supported students in the PBP course.'),
      findsOneWidget,
    );
    expect(find.text('Kategori: Full-Time'), findsOneWidget);
    expect(find.text('Selesai: Ongoing'), findsOneWidget);
    expect(find.text('Thumbnail: Tidak ada'), findsOneWidget);
  });
}
