import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kinoapay_app/core/errors/app_exception.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/features/accounts/infrastructure/repositories/mock_auth_repository.dart";

/// Vérifie que la réinitialisation du mot de passe cible bien le compte qui
/// a démarré le flow (et non systématiquement le premier compte du store).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel(
    "plugins.it_nomads.com/flutter_secure_storage",
  );
  final fakeStore = <String, String>{};

  setUp(() {
    fakeStore.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      switch (call.method) {
        case "write":
          fakeStore[call.arguments["key"] as String] =
              call.arguments["value"] as String;
          return null;
        case "read":
          return fakeStore[call.arguments["key"] as String];
        case "delete":
          fakeStore.remove(call.arguments["key"] as String);
          return null;
        case "deleteAll":
          fakeStore.clear();
          return null;
        case "containsKey":
          return fakeStore.containsKey(call.arguments["key"] as String);
        case "readAll":
          return Map<String, String>.from(fakeStore);
      }
      return null;
    });
  });

  group("MockAuthRepository password reset", () {
    test(
      "applique le nouveau mot de passe au compte demandeur (pas au premier)",
      () async {
        final repo = MockAuthRepository(storage: const SecureStorageService());

        // Sanity : les comptes seedés se connectent avec leur mot de passe initial.
        await repo.signIn("delphy@kinoapay.com", "password123");
        await repo.signIn("test@kinoapay.com", "password123");

        // Flow complet de reset pour delphy uniquement.
        await repo.requestPasswordReset(
          "delphy@kinoapay.com",
          isEmail: true,
        );
        final token =
            await repo.verifyResetOtp("delphy@kinoapay.com", "123456");
        await repo.resetPassword(token, "newDelphyPass");

        // Delphy se connecte avec le nouveau mot de passe.
        await repo.signIn("delphy@kinoapay.com", "newDelphyPass");

        // Le mot de passe de test@kinoapay.com NE doit pas avoir bougé.
        await repo.signIn("test@kinoapay.com", "password123");

        // …et inversement, le nouveau mot de passe de delphy ne marche pas
        // pour test@kinoapay.com.
        await expectLater(
          repo.signIn("test@kinoapay.com", "newDelphyPass"),
          throwsA(isA<AppException>()),
        );

        // L'ancien mot de passe de delphy doit avoir été révoqué.
        await expectLater(
          repo.signIn("delphy@kinoapay.com", "password123"),
          throwsA(isA<AppException>()),
        );
      },
    );

    test("rejette les tokens de reset invalides", () async {
      final repo = MockAuthRepository(storage: const SecureStorageService());
      await expectLater(
        repo.resetPassword("not_a_real_token", "whatever"),
        throwsA(isA<AppException>()),
      );
    });

    test(
      "verifyResetOtp échoue si le contact ne correspond à aucun compte",
      () async {
        final repo = MockAuthRepository(storage: const SecureStorageService());
        await expectLater(
          repo.verifyResetOtp("nobody@example.com", "123456"),
          throwsA(isA<AppException>()),
        );
      },
    );
  });
}
