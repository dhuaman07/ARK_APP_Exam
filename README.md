# Flutter Login App - Clean Architecture

Una aplicación Flutter con arquitectura limpia (Clean Architecture) que incluye un diseño moderno de login con animaciones y efectos visuales distintivos.

## 🎨 Características del Diseño

- **Animaciones fluidas**: Transiciones suaves y efectos de escala
- **Fondo animado**: Partículas flotantes con colores cian y magenta
- **Campos de texto personalizados**: Efectos de enfoque con gradientes y sombras
- **Botón con gradiente**: Animaciones de presión y efectos de brillo
- **Paleta de colores distintiva**: Azules profundos, cian brillante y magenta
- **Tema oscuro**: Diseño futurista con elementos luminosos

## 🏗️ Arquitectura

El proyecto sigue los principios de Clean Architecture con tres capas principales:

### 1. Domain Layer (Capa de Dominio)
```
features/auth/domain/
├── entities/          # Entidades de negocio
├── repositories/      # Contratos de repositorios
└── usecases/         # Casos de uso
```

### 2. Data Layer (Capa de Datos)
```
features/auth/data/
├── models/           # Modelos con serialización
├── datasources/      # Fuentes de datos (API, Local)
└── repositories/     # Implementación de repositorios
```

### 3. Presentation Layer (Capa de Presentación)
```
features/auth/presentation/
├── bloc/            # Gestión de estado con BLoC
├── pages/           # Pantallas
└── widgets/         # Widgets reutilizables
```

## 📦 Dependencias Principales

- **flutter_bloc**: Gestión de estado
- **get_it**: Inyección de dependencias
- **dio**: Cliente HTTP
- **shared_preferences**: Almacenamiento local
- **flutter_secure_storage**: Almacenamiento seguro
- **dartz**: Programación funcional
- **equatable**: Comparación de objetos

## 🚀 Instalación

1. Clona el repositorio:
```bash
git clone <tu-repositorio>
cd flutter_login_app
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Configura tu URL de API en `lib/injection_container.dart`:
```dart
baseUrl: 'https://tu-api.com/api', // Reemplazar con tu URL
```

4. Ejecuta la aplicación:
```bash
flutter run
```

## 🔧 Configuración

### Configurar el Backend

Actualiza la URL base en `lib/injection_container.dart`:

```dart
sl.registerLazySingleton(() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://tu-api.com/api',
      // ...
    ),
  );
  return dio;
});
```

### Endpoints Esperados

La app espera los siguientes endpoints:

- **POST** `/auth/login`
  ```json
  {
    "email": "usuario@example.com",
    "password": "password123"
  }
  ```

- **POST** `/auth/logout`

## 📱 Estructura de Pantallas

### Login Page
- Email y contraseña con validación
- Animaciones de entrada
- Botones de redes sociales
- Enlace a registro
- Recuperación de contraseña

## 🎯 Próximos Pasos

1. **Implementar Registro**
   - Crear página de registro
   - Añadir caso de uso `RegisterUser`
   - Validación de datos

2. **Implementar Home**
   - Crear pantalla principal
   - Navegación entre pantallas
   - Perfil de usuario

3. **Implementar Recuperación de Contraseña**
   - Página de recuperación
   - Envío de email
   - Reset de contraseña

4. **Testing**
   - Tests unitarios para casos de uso
   - Tests de widgets
   - Tests de integración

## 📝 Notas de Desarrollo

### BLoC Pattern

El proyecto utiliza BLoC para la gestión de estado:

```dart
// Emitir evento
context.read<AuthBloc>().add(LoginRequested(
  email: email,
  password: password,
));

// Escuchar estados
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthError) {
      // Mostrar error
    }
  },
  builder: (context, state) {
    // Construir UI basada en estado
  },
)
```

### Inyección de Dependencias

Todas las dependencias se registran en `injection_container.dart`:

```dart
// Obtener dependencia
final authBloc = sl<AuthBloc>();
```

### Validación de Formularios

Los validadores están en `lib/core/utils/validators.dart`:

```dart
validator: Validators.validateEmail,
```

## 🎨 Personalización

### Colores

Modifica los colores en los widgets para cambiar el tema:

```dart
const Color(0xFF00F5FF), // Cian
const Color(0xFFFF006E), // Magenta
const Color(0xFF0080FF), // Azul
```

### Animaciones

Ajusta las duraciones en los widgets:

```dart
duration: const Duration(milliseconds: 1200),
```

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Haz fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📧 Contacto

Para preguntas o sugerencias, por favor abre un issue en el repositorio.
