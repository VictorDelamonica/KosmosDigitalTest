// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter_test/flutter_test.dart';
import 'package:kosmos_digital_test/src/features/connections/service/connection_service.dart';

/// Integration tests for ConnectionService
///
/// These tests verify the service layer integrations and validation logic.
/// Tests that require Firebase initialization are skipped in unit test environment.
/// For full Firebase integration testing, use Firebase Test Lab or emulators.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConnectionService Integration Tests', () {
    late ConnectionService connectionService;

    setUp(() {
      connectionService = ConnectionService();
    });

    group('Email Validation Tests', () {
      test('should validate correct email formats', () {
        expect(connectionService.validateEmail('test@example.com'), true);
        expect(connectionService.validateEmail('user.name@domain.co.uk'), true);
        expect(connectionService.validateEmail('user+tag@example.com'), true);
        expect(
          connectionService.validateEmail('test_user@test-domain.com'),
          true,
        );
        expect(connectionService.validateEmail('a@b.c'), true);
      });

      test('should reject invalid email formats', () {
        expect(connectionService.validateEmail('invalid'), false);
        expect(connectionService.validateEmail('invalid@'), false);
        expect(connectionService.validateEmail('@example.com'), false);
        expect(connectionService.validateEmail('invalid@example'), false);
        expect(connectionService.validateEmail(''), false);
        expect(connectionService.validateEmail('test..test@'), false);
        expect(connectionService.validateEmail('test@'), false);
      });

      test('should handle edge cases for email validation', () {
        expect(connectionService.validateEmail('test@test@test.com'), false);
        expect(connectionService.validateEmail('test..test@example.com'), true);
        expect(connectionService.validateEmail('test test@example.com'), true);
        expect(connectionService.validateEmail('1234567890@example.com'), true);
      });

      test('should handle special characters in email', () {
        expect(
          connectionService.validateEmail('test+filter@example.com'),
          true,
        );
        expect(connectionService.validateEmail('test.dot@example.com'), true);
        expect(
          connectionService.validateEmail('test_underscore@example.com'),
          true,
        );
        expect(connectionService.validateEmail('test-dash@example.com'), true);
      });
    });

    group('Password Validation Tests', () {
      test('should accept passwords with 6 or more characters', () {
        expect(connectionService.validatePassword('123456'), true);
        expect(connectionService.validatePassword('password'), true);
        expect(
          connectionService.validatePassword('VeryLongPassword123!'),
          true,
        );
        expect(connectionService.validatePassword('abcdef'), true);
      });

      test('should reject passwords with less than 6 characters', () {
        expect(connectionService.validatePassword('12345'), false);
        expect(connectionService.validatePassword('abc'), false);
        expect(connectionService.validatePassword(''), false);
        expect(connectionService.validatePassword('a'), false);
        expect(connectionService.validatePassword('12'), false);
      });

      test('should handle special characters in passwords', () {
        expect(connectionService.validatePassword('Pass@1'), true);
        expect(connectionService.validatePassword('!@#\$%^&*'), true);
        expect(connectionService.validatePassword('      '), true); // 6 spaces
        expect(connectionService.validatePassword('测试密码123'), true); // Unicode
      });

      test('should handle boundary conditions', () {
        expect(connectionService.validatePassword('12345'), false); // 5 chars
        expect(connectionService.validatePassword('123456'), true); // 6 chars
        expect(connectionService.validatePassword('1234567'), true); // 7 chars
      });
    });

    group('Password Match Tests', () {
      test('should return true when passwords match exactly', () {
        expect(
          connectionService.passwordsMatch('password123', 'password123'),
          true,
        );
        expect(connectionService.passwordsMatch('', ''), true);
        expect(connectionService.passwordsMatch('Test@123', 'Test@123'), true);
        expect(connectionService.passwordsMatch('a', 'a'), true);
      });

      test('should return false when passwords do not match', () {
        expect(
          connectionService.passwordsMatch('password1', 'password2'),
          false,
        );
        expect(connectionService.passwordsMatch('Test', 'test'), false);
        expect(connectionService.passwordsMatch('password', ''), false);
        expect(connectionService.passwordsMatch('', 'password'), false);
      });

      test('should be case sensitive', () {
        expect(connectionService.passwordsMatch('Password', 'password'), false);
        expect(connectionService.passwordsMatch('TEST', 'test'), false);
        expect(connectionService.passwordsMatch('PaSsWoRd', 'password'), false);
      });

      test('should handle special characters', () {
        expect(
          connectionService.passwordsMatch('Pass@123!', 'Pass@123!'),
          true,
        );
        expect(
          connectionService.passwordsMatch('Pass@123!', 'Pass@123'),
          false,
        );
      });
    });

    group('Sign In Validation Integration Tests', () {
      test('should throw exception for invalid email during sign in', () async {
        await expectLater(
          connectionService.singInViaFirebaseEmailPassword(
            'invalid-email',
            'password123',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Email ou mot de passe invalide'),
            ),
          ),
        );
      });

      test(
        'should throw exception for invalid password during sign in',
        () async {
          await expectLater(
            connectionService.singInViaFirebaseEmailPassword(
              'test@example.com',
              '12345', // Less than 6 characters
            ),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Email ou mot de passe invalide'),
              ),
            ),
          );
        },
      );

      test('should throw exception for both invalid credentials', () async {
        await expectLater(
          connectionService.singInViaFirebaseEmailPassword('invalid', '123'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Email ou mot de passe invalide'),
            ),
          ),
        );
      });

      test('should validate inputs before attempting Firebase call', () async {
        final invalidCombinations = [
          ['', 'password123'],
          ['test@example.com', ''],
          ['invalid', 'short'],
          ['@test.com', '12345'],
        ];

        for (final combo in invalidCombinations) {
          await expectLater(
            connectionService.singInViaFirebaseEmailPassword(
              combo[0],
              combo[1],
            ),
            throwsA(isA<Exception>()),
          );
        }
      });
    });

    group('End-to-End Workflow Tests', () {
      test('complete registration workflow validation', () {
        const email = 'newuser@example.com';
        const password = 'SecurePass123!';
        const confirmPassword = 'SecurePass123!';

        // Step 1: Validate email
        final emailValid = connectionService.validateEmail(email);
        expect(emailValid, true);

        // Step 2: Validate password strength
        final passwordValid = connectionService.validatePassword(password);
        expect(passwordValid, true);

        // Step 3: Confirm passwords match
        final passwordsMatch = connectionService.passwordsMatch(
          password,
          confirmPassword,
        );
        expect(passwordsMatch, true);

        // All validations pass - ready for registration
        expect(emailValid && passwordValid && passwordsMatch, true);
      });

      test('complete login workflow validation', () {
        const email = 'user@example.com';
        const password = 'password123';

        // Step 1: Validate email format
        expect(connectionService.validateEmail(email), true);

        // Step 2: Validate password length
        expect(connectionService.validatePassword(password), true);
      });

      test('password change workflow validation', () {
        const currentPassword = 'oldPassword123';
        const newPassword = 'newPassword456';
        const confirmNewPassword = 'newPassword456';

        // Validate current password
        expect(connectionService.validatePassword(currentPassword), true);

        // Validate new password
        expect(connectionService.validatePassword(newPassword), true);

        // Confirm new passwords match
        expect(
          connectionService.passwordsMatch(newPassword, confirmNewPassword),
          true,
        );

        // Ensure new password is different
        expect(
          connectionService.passwordsMatch(currentPassword, newPassword),
          false,
        );
      });
    });

    group('Error Handling Tests', () {
      test('should handle empty string inputs', () {
        expect(connectionService.validateEmail(''), false);
        expect(connectionService.validatePassword(''), false);
        expect(connectionService.passwordsMatch('', ''), true);
      });

      test('should handle whitespace inputs', () {
        expect(connectionService.validateEmail('   '), false);
        expect(connectionService.validatePassword('     '), false); // 5 spaces
        expect(connectionService.validatePassword('      '), true); // 6 spaces
      });

      test('should handle very long inputs', () {
        final longEmail = '${'a' * 100}@${'b' * 100}.${'c' * 100}';
        final longPassword = 'a' * 1000;

        expect(connectionService.validateEmail(longEmail), true);
        expect(connectionService.validatePassword(longPassword), true);
      });

      test('should handle unicode characters', () {
        expect(connectionService.validateEmail('用户@example.com'), true);
        expect(connectionService.validatePassword('密码测试123'), true);
        expect(connectionService.validateEmail('tëst@ëxamplë.com'), true);
      });
    });

    group('Security Validation Tests', () {
      test('should enforce minimum password length requirement', () {
        final passwords = ['', 'a', 'ab', 'abc', 'abcd', 'abcde', 'abcdef'];
        final expected = [false, false, false, false, false, false, true];

        for (var i = 0; i < passwords.length; i++) {
          expect(
            connectionService.validatePassword(passwords[i]),
            expected[i],
            reason: 'Password "${passwords[i]}" should be ${expected[i]}',
          );
        }
      });

      test('should validate various email formats correctly', () {
        final validEmails = [
          'simple@example.com',
          'very.common@example.com',
          'disposable.style.email.with+symbol@example.com',
          'other.email-with-hyphen@example.com',
          'fully-qualified-domain@example.com',
          'user.name+tag+sorting@example.com',
          'x@example.com',
          'example-indeed@strange-example.com',
          'test/test@test.com',
        ];

        for (final email in validEmails) {
          expect(
            connectionService.validateEmail(email),
            true,
            reason: 'Email "$email" should be valid',
          );
        }
      });

      test('should reject malformed email addresses', () {
        final invalidEmails = [
          'plainaddress',
          '@no-local-part.com',
          'missing-domain@.com',
          'missing-tld@domain.',
          'two@@signs.com',
        ];

        for (final email in invalidEmails) {
          expect(
            connectionService.validateEmail(email),
            false,
            reason: 'Email "$email" should be invalid',
          );
        }
      });
    });

    group('Performance and Stress Tests', () {
      test('should handle multiple rapid validation calls', () {
        final stopwatch = Stopwatch()..start();

        for (var i = 0; i < 1000; i++) {
          connectionService.validateEmail('test$i@example.com');
          connectionService.validatePassword('password$i');
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('should handle concurrent validation requests', () {
        final futures = List.generate(100, (i) {
          return Future(() {
            connectionService.validateEmail('test$i@example.com');
            connectionService.validatePassword('password$i');
            return true;
          });
        });

        expect(Future.wait(futures), completes);
      });
    });

    group('Regression Tests', () {
      test('should maintain backward compatibility with email validation', () {
        expect(connectionService.validateEmail('admin@company.com'), true);
        expect(connectionService.validateEmail('user@domain.co'), true);
        expect(connectionService.validateEmail('test'), false);
      });

      test(
        'should maintain backward compatibility with password validation',
        () {
          expect(connectionService.validatePassword('123456'), true);
          expect(connectionService.validatePassword('12345'), false);
        },
      );

      test('should maintain exact password matching behavior', () {
        expect(connectionService.passwordsMatch('abc', 'abc'), true);
        expect(connectionService.passwordsMatch('abc', 'ABC'), false);
      });
    });
  });
}
