# Guía de Uso - Flutter Login App

## 🎯 Cómo usar la aplicación

### 1. Iniciar la App

```bash
# Desarrollo
flutter run

# Modo release
flutter run --release

# Para un dispositivo específico
flutter run -d <device-id>
```

### 2. Estructura del Código

#### Añadir un nuevo Feature

Para añadir un nuevo feature siguiendo Clean Architecture:

```
lib/features/nuevo_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

#### Ejemplo: Añadir Feature de Perfil

1. **Crear la Entidad** (Domain)
```dart
// lib/features/profile/domain/entities/profile.dart
class Profile extends Equatable {
  final String id;
  final String name;
  final String bio;
  
  const Profile({
    required this.id,
    required this.name,
    required this.bio,
  });
  
  @override
  List<Object> get props => [id, name, bio];
}
```

2. **Crear el Caso de Uso** (Domain)
```dart
// lib/features/profile/domain/usecases/get_profile.dart
class GetProfile implements UseCase<Profile, NoParams> {
  final ProfileRepository repository;
  
  GetProfile(this.repository);
  
  @override
  Future<Either<Failure, Profile>> call(NoParams params) async {
    return await repository.getProfile();
  }
}
```

3. **Crear el Modelo** (Data)
```dart
// lib/features/profile/data/models/profile_model.dart
class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.bio,
  });
  
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
    };
  }
}
```

4. **Registrar en Dependency Injection**
```dart
// lib/injection_container.dart

// Bloc
sl.registerFactory(() => ProfileBloc(getProfile: sl()));

// Use case
sl.registerLazySingleton(() => GetProfile(sl()));

// Repository
sl.registerLazySingleton<ProfileRepository>(
  () => ProfileRepositoryImpl(remoteDataSource: sl()),
);
```

### 3. Testing

#### Test Unitario de Use Case

```dart
// test/features/auth/domain/usecases/login_user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

void main() {
  late LoginUser usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUser(mockAuthRepository);
  });

  test('should return User when login is successful', () async {
    // arrange
    final tUser = User(
      id: '1',
      email: 'test@test.com',
      name: 'Test User',
    );
    
    when(mockAuthRepository.login(
      email: any,
      password: any,
    )).thenAnswer((_) async => Right(tUser));

    // act
    final result = await usecase(LoginParams(
      email: 'test@test.com',
      password: 'password',
    ));

    // assert
    expect(result, Right(tUser));
    verify(mockAuthRepository.login(
      email: 'test@test.com',
      password: 'password',
    ));
  });
}
```

### 4. Comandos Útiles

```bash
# Limpiar proyecto
flutter clean

# Obtener dependencias
flutter pub get

# Ejecutar tests
flutter test

# Generar código (si usas build_runner)
flutter pub run build_runner build --delete-conflicting-outputs

# Analizar código
flutter analyze

# Formatear código
dart format .

# Ver dispositivos disponibles
flutter devices

# Crear APK
flutter build apk --release

# Crear App Bundle
flutter build appbundle --release

# Crear IPA (iOS)
flutter build ios --release
```

### 5. Debugging

#### Print Statements
```dart
print('Estado actual: $state');
debugPrint('Valor: $value');
```

#### Breakpoints en VSCode/Android Studio
- Coloca breakpoints haciendo clic en el margen izquierdo
- Usa F5 para iniciar debugging
- F10 para step over
- F11 para step into

#### Flutter DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### 6. Configuración de IDE

#### VSCode

Instala las extensiones:
- Flutter
- Dart
- Flutter Widget Snippets

#### Android Studio

Instala los plugins:
- Flutter
- Dart

### 7. Tips de Desarrollo

#### Hot Reload vs Hot Restart

```
r - Hot reload (mantiene el estado)
R - Hot restart (reinicia la app)
q - Salir
```

#### Snippets Útiles

En VSCode, escribe:
- `stl` → StatelessWidget
- `stf` → StatefulWidget
- `bloc` → BlocBuilder
- `blocl` → BlocListener

### 8. Manejo de Errores Comunes

#### Error: "A RenderFlex overflowed"
**Solución**: Envuelve el widget en `SingleChildScrollView`

#### Error: "The getter 'X' was called on null"
**Solución**: Usa null-safety operators (`?.`, `??`, `!`)

#### Error: "setState() called after dispose()"
**Solución**: Verifica si el widget está montado:
```dart
if (mounted) {
  setState(() {});
}
```

### 9. Buenas Prácticas

1. **Siempre usa const** cuando sea posible
```dart
const Text('Hello') // ✅
Text('Hello')        // ❌
```

2. **Extrae widgets complejos**
```dart
// ✅ Mejor
class CustomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(...);
  }
}

// ❌ Evitar widgets muy largos
Widget build(BuildContext context) {
  return Column(
    children: [
      // 100 líneas de código...
    ],
  );
}
```

3. **Usa nombres descriptivos**
```dart
final isUserLoggedIn = true;  // ✅
final flag = true;             // ❌
```

4. **Maneja todos los estados**
```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) return LoadingWidget();
    if (state is Authenticated) return HomeScreen();
    if (state is AuthError) return ErrorWidget();
    return LoginScreen(); // Estado por defecto
  },
)
```

### 10. Recursos Adicionales

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Library](https://bloclibrary.dev/)
- [Clean Architecture en Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
