import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';
import 'package:tradeverse/features/profile/presentation/view/profile_view.dart';
import 'package:tradeverse/features/profile/presentation/view_model/profile_event.dart';
import 'package:tradeverse/features/profile/presentation/view_model/profile_state.dart';
import 'package:tradeverse/features/profile/presentation/view_model/profile_view_model.dart';

// --- MOCKS AND FAKES ---
class MockProfileViewModel extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileViewModel {}

class MockImagePickerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements ImagePickerPlatform {}

class FakeProfileEvent extends Fake implements ProfileEvent {}

class FakeProfileState extends Fake implements ProfileState {}

// --- HTTP CLIENT MOCK FOR NETWORK IMAGES ---
class MockHttpClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) =>
      Future.value(MockHttpClientRequest());
}

class MockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  final HttpHeaders headers = MockHttpHeaders();
  @override
  Future<HttpClientResponse> close() => Future.value(MockHttpClientResponse());
}

class MockHttpClientResponse extends Mock implements HttpClientResponse {
  static final _transparentImage = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
  );
  @override
  int get statusCode => HttpStatus.ok;
  @override
  int get contentLength => _transparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream.value(_transparentImage).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class MockHttpHeaders extends Mock implements HttpHeaders {}

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => MockHttpClient();
}

void main() {
  late MockProfileViewModel mockProfileViewModel;
  late MockImagePickerPlatform mockImagePicker;
  late ProfileEntity testProfile;
  late XFile fakeImage;

  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
    registerFallbackValue(const ImagePickerOptions());
    registerFallbackValue(FakeProfileEvent());
    registerFallbackValue(FakeProfileState());
  });

  setUp(() async {
    mockProfileViewModel = MockProfileViewModel();
    when(() => mockProfileViewModel.add(any())).thenReturn(null);
    mockImagePicker = MockImagePickerPlatform();
    ImagePickerPlatform.instance = mockImagePicker;
    fakeImage = XFile('test/fake_image.jpg');
    testProfile = const ProfileEntity(
      id: '1',
      user: UserDetailEntity(
        fullName: 'John Doe',
        email: 'john.doe@example.com',
      ),
      subscription: SubscriptionEntity(plan: 'Premium'),
      firstName: 'John',
      lastName: 'Doe',
      bio: 'A sample bio',
      avatar: 'http://example.com/avatar.png',
    );
  });

  Future<void> pumpWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProfileViewModel>.value(
          value: mockProfileViewModel,
          child: const ProfileView(),
        ),
      ),
    );
  }

  group('ProfileView', () {
    testWidgets('dispatches LoadProfile on initState', (tester) async {
      when(() => mockProfileViewModel.state).thenReturn(ProfileLoading());
      await pumpWidget(tester);
      verify(() => mockProfileViewModel.add(LoadProfile())).called(1);
    });

    group('UI Rendering based on State', () {
      testWidgets('shows loading indicator on initial load', (tester) async {
        when(() => mockProfileViewModel.state).thenReturn(ProfileLoading());
        await pumpWidget(tester);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows error message on initial load failure', (
        tester,
      ) async {
        const error = 'Failed to load profile';
        when(
          () => mockProfileViewModel.state,
        ).thenReturn(const ProfileError(message: error));
        await pumpWidget(tester);
        expect(find.text('Error: $error'), findsOneWidget);
      });

      testWidgets('populates form fields when profile is loaded', (
        tester,
      ) async {
        whenListen(
          mockProfileViewModel,
          Stream.fromIterable([ProfileLoaded(profile: testProfile)]),
          initialState: ProfileLoading(),
        );
        await pumpWidget(tester);
        await tester.pumpAndSettle();

        expect(find.text('John'), findsOneWidget);
        expect(find.text('Doe'), findsOneWidget);
        expect(find.text('john.doe@example.com'), findsOneWidget);
        expect(find.text('A sample bio'), findsOneWidget);
        expect(find.text('Premium'), findsOneWidget);
      });
    });

    group('Avatar Display Logic', () {
      testWidgets('displays NetworkImage for http avatar URL', (tester) async {
        whenListen(
          mockProfileViewModel,
          Stream.fromIterable([ProfileLoaded(profile: testProfile)]),
          initialState: ProfileLoading(),
        );
        await pumpWidget(tester);
        await tester.pumpAndSettle();
        final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
        expect(avatar.backgroundImage, isA<NetworkImage>());
      });
      testWidgets('displays person icon when avatar is null', (tester) async {
        final noAvatarProfile = ProfileEntity(
          id: testProfile.id,
          user: testProfile.user,
          subscription: testProfile.subscription,
          firstName: testProfile.firstName,
          lastName: testProfile.lastName,
          bio: testProfile.bio,
          avatar: null, // Explicitly set avatar to null
        );

        whenListen(
          mockProfileViewModel,
          Stream.fromIterable([ProfileLoaded(profile: noAvatarProfile)]),
          initialState: ProfileLoading(),
        );

        // Act
        await pumpWidget(tester);
        await tester.pumpAndSettle();

        // Assert
        // The test will now pass because the avatar is correctly null.
        expect(find.byIcon(Icons.person), findsOneWidget);
        final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
        expect(avatar.backgroundImage, isNull);
      });
    });

    group('Listener Logic (SnackBars)', () {
      testWidgets('shows loaded/updated SnackBar on ProfileLoaded', (
        tester,
      ) async {
        whenListen(
          mockProfileViewModel,
          Stream.fromIterable([ProfileLoaded(profile: testProfile)]),
          initialState: ProfileLoading(),
        );
        await pumpWidget(tester);
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('shows saving SnackBar when updating an existing profile', (
        tester,
      ) async {
        // Arrange: Simulate the flow: Loading -> Loaded -> Updating
        whenListen(
          mockProfileViewModel,
          Stream.fromIterable([
            ProfileLoaded(profile: testProfile), // State 1
            ProfileLoading(), // State 2 (the update)
          ]),
          initialState: ProfileLoading(), // State 0
        );

        // Act:
        await pumpWidget(tester);
        await tester.pump();
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Saving profile...'), findsOneWidget);
      });
    });

    group('Image Picking', () {
      testWidgets('updates avatar when an image is successfully picked', (
        tester,
      ) async {
        whenListen(
          mockProfileViewModel,
          Stream.fromIterable([ProfileLoaded(profile: testProfile)]),
          initialState: ProfileLoading(),
        );
        when(
          () => mockImagePicker.getImageFromSource(
            source: ImageSource.gallery,
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => fakeImage);
        await pumpWidget(tester);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Change Avatar'));
        await tester.pumpAndSettle();

        final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
        expect(avatar.backgroundImage, isA<FileImage>());
      });
    });

    group('Profile Updating', () {
      testWidgets('shows validation error if name is empty', (tester) async {
        whenListen(
          mockProfileViewModel,
          Stream.fromIterable([ProfileLoaded(profile: testProfile)]),
          initialState: ProfileLoaded(profile: testProfile),
        );

        await pumpWidget(tester);
        await tester.pumpAndSettle();

        // Clear the first name field
        final firstNameField = find.byKey(const Key('firstName_textField'));
        await tester.enterText(firstNameField, '');
        await tester.pumpAndSettle();

        // Tap save button
        final saveButton = find.byKey(const Key('save_changes_button'));
        await tester.ensureVisible(saveButton);
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Assert validation error
        expect(find.text('Please enter your first name'), findsOneWidget);
      });

      // testWidgets('dispatches UpdateProfileEvent with new avatar file', (
      //   tester,
      // ) async {
      //   // Arrange: mock states stream - start Loading, then Loaded
      //   whenListen(
      //     mockProfileViewModel,
      //     Stream.fromIterable([
      //       ProfileLoading(),
      //       ProfileLoaded(profile: testProfile),
      //     ]),
      //     initialState: ProfileLoading(),
      //   );

      //   when(
      //     () => mockImagePicker.getImageFromSource(
      //       source: ImageSource.gallery,
      //       options: any(named: 'options'),
      //     ),
      //   ).thenAnswer((_) async => fakeImage);

      //   await pumpWidget(tester);

      //   // Let UI rebuild with ProfileLoaded state
      //   await tester.pumpAndSettle();

      //   // Fill required form fields to ensure form validity (e.g., first name)
      //   final firstNameField = find.byKey(const Key('firstName_textField'));
      //   await tester.enterText(firstNameField, testProfile.firstName);
      //   await tester.pumpAndSettle();

      //   final lastNameField = find.byKey(const Key('lastName_textField'));
      //   await tester.enterText(lastNameField, testProfile.lastName);

      //   final bioField = find.byKey(const Key('bio_textField'));
      //   await tester.enterText(bioField, testProfile.bio);

      //   await tester.pumpAndSettle();

      //   // Tap 'Change Avatar' button to pick an image (simulate image picking)
      //   await tester.tap(find.text('Change Avatar'));
      //   await tester.pumpAndSettle();

      //   // Find save button
      //   final saveButtonFinder = find.byKey(const Key('save_changes_button'));
      //   expect(saveButtonFinder, findsOneWidget);

      //   // Ensure the save button is visible (scroll if needed)
      //   await tester.ensureVisible(saveButtonFinder);
      //   await tester.pumpAndSettle();

      //   // Check the save button is enabled (onPressed not null)
      //   final saveButton = tester.widget<ElevatedButton>(saveButtonFinder);
      //   print('Save button enabled: ${saveButton.onPressed != null}');
      //   expect(saveButton.onPressed != null, true);

      //   // Tap the save button
      //   await tester.tap(saveButtonFinder);
      //   await tester.pumpAndSettle();

      //   // Verify UpdateProfileEvent dispatched with the correct avatar file path
      //   final capturedEvents =
      //       verify(() => mockProfileViewModel.add(captureAny())).captured;
      //   final updateEvents =
      //       capturedEvents.whereType<UpdateProfileEvent>().toList();
      //   expect(updateEvents, isNotEmpty);

      //   final updateEvent = updateEvents.last;
      //   expect(updateEvent.avatarFile?.path, fakeImage.path);
      // });
    });
  });
}
