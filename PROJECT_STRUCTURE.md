# Estructura del Proyecto - Clean Architecture

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart
│   ├── usecases/
│   │   └── usecase.dart
│   └── utils/
│       └── validators.dart
│
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── auth_local_data_source.dart
│       │   │   └── auth_remote_data_source.dart
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   └── repositories/
│       │       └── auth_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user.dart
│       │   ├── repositories/
│       │   │   └── auth_repository.dart
│       │   └── usecases/
│       │       ├── login_user.dart
│       │       ├── logout_user.dart
│       │       └── get_current_user.dart
│       │
│       └── presentation/
│           ├── bloc/
│           │   ├── auth_bloc.dart
│           │   ├── auth_event.dart
│           │   └── auth_state.dart
│           ├── pages/
│           │   └── login_page.dart
│           └── widgets/
│               ├── custom_text_field.dart
│               ├── gradient_button.dart
│               └── animated_background.dart
│
├── injection_container.dart
└── main.dart
```

## Capas de Clean Architecture

### 1. **Domain Layer** (Capa de Dominio)
- **Entities**: Objetos de negocio puros
- **Repositories**: Interfaces/contratos
- **Use Cases**: Lógica de negocio específica

### 2. **Data Layer** (Capa de Datos)
- **Models**: Implementación de entidades con serialización
- **Data Sources**: Acceso a datos (API, Base de datos local)
- **Repository Implementation**: Implementación de los contratos

### 3. **Presentation Layer** (Capa de Presentación)
- **BLoC/Cubit**: Gestión de estado
- **Pages**: Pantallas de la aplicación
- **Widgets**: Componentes reutilizables

### 4. **Core**
- Utilidades compartidas
- Constantes
- Manejo de errores
- Casos de uso base
