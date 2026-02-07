# Diagrama de Arquitectura Clean Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                           │
│                    (UI, Widgets, State Management)                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌────────────────┐      ┌──────────────────┐                       │
│  │  LoginPage     │◄─────┤   AuthBloc       │                       │
│  │                │      │                  │                       │
│  │  - UI          │      │  - Events        │                       │
│  │  - Formulario  │      │  - States        │                       │
│  │  - Animaciones │      │  - Logic         │                       │
│  └────────────────┘      └──────────────────┘                       │
│         ▲                         │                                  │
│         │                         │ usa                              │
│         │                         ▼                                  │
│  ┌─────────────────────────────────────┐                            │
│  │  Widgets Personalizados             │                            │
│  │  - CustomTextField                  │                            │
│  │  - GradientButton                   │                            │
│  │  - AnimatedBackground               │                            │
│  └─────────────────────────────────────┘                            │
│                                                                       │
└───────────────────────────────────┬───────────────────────────────────┘
                                    │
                                    │ depende de
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                           DOMAIN LAYER                               │
│                   (Business Logic, Entities)                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌────────────────┐      ┌──────────────────┐                       │
│  │   User         │      │  AuthRepository  │                       │
│  │   (Entity)     │      │  (Interface)     │                       │
│  │                │      │                  │                       │
│  │  - id          │      │  - login()       │                       │
│  │  - email       │      │  - logout()      │                       │
│  │  - name        │      │  - getUser()     │                       │
│  └────────────────┘      └──────────────────┘                       │
│                                    ▲                                 │
│                                    │                                 │
│                          ┌─────────┴─────────┐                      │
│                          │                   │                      │
│                  ┌───────┴────────┐  ┌──────┴────────┐             │
│                  │  LoginUser     │  │  LogoutUser   │             │
│                  │  (UseCase)     │  │  (UseCase)    │             │
│                  │                │  │               │             │
│                  │  - call()      │  │  - call()     │             │
│                  └────────────────┘  └───────────────┘             │
│                                                                       │
└───────────────────────────────────┬───────────────────────────────────┘
                                    │
                                    │ implementa
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                            DATA LAYER                                │
│                  (API, Database, Implementation)                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌──────────────────────────────────────────────────────────┐       │
│  │              AuthRepositoryImpl                          │       │
│  │              (Repository Implementation)                 │       │
│  └─────────────────────┬────────────────────────────────────┘       │
│                        │                                             │
│            ┌───────────┴───────────┐                                │
│            │                       │                                │
│            ▼                       ▼                                │
│  ┌───────────────────┐   ┌──────────────────┐                      │
│  │ AuthRemoteData    │   │ AuthLocalData    │                      │
│  │ Source            │   │ Source           │                      │
│  │                   │   │                  │                      │
│  │ - Dio (HTTP)      │   │ - SharedPref     │                      │
│  │ - API Calls       │   │ - SecureStorage  │                      │
│  │ - login()         │   │ - cacheUser()    │                      │
│  │ - logout()        │   │ - getUser()      │                      │
│  └───────────────────┘   └──────────────────┘                      │
│            │                       │                                │
│            ▼                       ▼                                │
│  ┌───────────────────┐   ┌──────────────────┐                      │
│  │   UserModel       │   │   UserModel      │                      │
│  │   (Data Model)    │   │   (Cached)       │                      │
│  │                   │   │                  │                      │
│  │ - fromJson()      │   │ - toJson()       │                      │
│  │ - toJson()        │   │                  │                      │
│  │ - toEntity()      │   │                  │                      │
│  └───────────────────┘   └──────────────────┘                      │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                             CORE LAYER                               │
│                    (Shared Utilities, Constants)                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌────────────────┐  ┌──────────────┐  ┌─────────────────┐         │
│  │   Failures     │  │  Exceptions  │  │   Validators    │         │
│  │                │  │              │  │                 │         │
│  │ - Server       │  │ - Server     │  │ - validateEmail │         │
│  │ - Network      │  │ - Network    │  │ - validatePass  │         │
│  │ - Cache        │  │ - Cache      │  │                 │         │
│  └────────────────┘  └──────────────┘  └─────────────────┘         │
│                                                                       │
│  ┌────────────────────────────────────────────────────┐             │
│  │              UseCase (Base Class)                  │             │
│  │              - call(params)                        │             │
│  └────────────────────────────────────────────────────┘             │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                      DEPENDENCY INJECTION                            │
│                         (GetIt Container)                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  - Registra todas las dependencias                                  │
│  - Gestiona el ciclo de vida de objetos                             │
│  - Factory, Singleton, LazySingleton                                │
│                                                                       │
│  Ejemplo:                                                            │
│  sl.registerFactory(() => AuthBloc(loginUser: sl()));               │
│  sl.registerLazySingleton(() => LoginUser(sl()));                   │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘


FLUJO DE DATOS:
═════════════════

1. UI (LoginPage) → Usuario ingresa credenciales
                  ↓
2. BLoC → Recibe evento LoginRequested
                  ↓
3. UseCase → Ejecuta lógica de negocio (LoginUser)
                  ↓
4. Repository → Llama al datasource apropiado
                  ↓
5. DataSource → Hace petición HTTP / Lee cache
                  ↓
6. Model → Convierte JSON a objeto
                  ↓
7. Entity → Devuelve entidad de dominio
                  ↓
8. BLoC → Emite nuevo estado (Authenticated)
                  ↓
9. UI → Actualiza interfaz con el nuevo estado


PRINCIPIOS APLICADOS:
═══════════════════════

✓ Separation of Concerns (Separación de responsabilidades)
✓ Dependency Inversion (Las capas superiores no dependen de las inferiores)
✓ Single Responsibility (Cada clase tiene una única responsabilidad)
✓ Open/Closed (Abierto para extensión, cerrado para modificación)
✓ Testability (Fácil de testear cada capa independientemente)


VENTAJAS DE ESTA ARQUITECTURA:
═══════════════════════════════

1. ✅ Código mantenible y escalable
2. ✅ Fácil de testear (unit tests, widget tests)
3. ✅ Independencia de frameworks
4. ✅ Separación clara de responsabilidades
5. ✅ Reutilización de código
6. ✅ Fácil de modificar sin afectar otras capas
7. ✅ Facilita el trabajo en equipo
