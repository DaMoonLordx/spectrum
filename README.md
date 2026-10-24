# Spectrum

## 1. Descripción breve

**Spectrum** es una app móvil social para conectar personas a partir de sus gustos musicales ("Encuentra tu frecuencia"). Cada usuario crea un perfil con sus géneros, artistas y canciones favoritas, descubre perfiles compatibles (con porcentaje de afinidad), da *Me gusta* o *Pasar*, y chatea con quienes tienen conexión mutua. Incluye minijuegos musicales (trivia, adivina la canción, completa el título) con récords y rachas, una sección *Explorar* con artistas y canciones, y ajustes de cuenta, apariencia, notificaciones y privacidad.

## 2. Los 3 tipos de usuario y sus dashboards

| Rol | Dashboard / funciones principales ||---|---|
| -> **Administrador** | *Panel de administración* con contadores de usuarios totales y activos, lista de usuarios (activar/desactivar con interruptor y eliminar), *Trivias* publicadas en el banco de preguntas y *Nueva trivia* para crear preguntas (4 opciones, respuesta correcta y dificultad). Navegación inferior: Usuarios · Trivias · Nueva trivia. |
| -> **Cliente** | Pantalla de inicio *Descubrir* (tarjetas de personas con % de compatibilidad, botones *Pasar* / *Me gusta*), *Explorar*, *Juegos*, *Chats* (conexiones mutuas) y *Perfil*. |
| -> **Operador** | *Reportes pendientes* de moderación: cada reporte se puede **Descartar** o **Revisar**. Al revisar se elige la acción (advertir al usuario, suspender 7 días o sin infracción), se agregan notas de moderación y se registra la resolución. |

El rol se elige al crear la cuenta.

## 3. Manejo de estado elegido (y por qué)

**Solución elegida:** `ChangeNotifier` (incluido en Flutter, sin paquetes externos), combinado con `setState` para el estado local de cada pantalla.

- **Estado compartido con `ChangeNotifier`:** `AuthController` (sesión y rol del usuario) y `TriviaController` (banco de trivias).
- **Estado local con `setState`:** indicadores de carga, filtros y búsquedas de las listas, visibilidad de la contraseña, rol y términos en el registro, y los campos de los formularios (por ejemplo, la respuesta correcta y la dificultad al crear una trivia).

**Justificación:** La sesión, el rol y las trivias se necesitan en varias pantallas y deben conservarse al navegar entre ellas, por lo que viven en controladores que notifican a la interfaz cuando cambian. El estado que solo importa a una pantalla se queda en `setState`, que es lo más simple para ese caso. Se eligió una solución nativa porque es suficiente para el alcance del proyecto, separa la lógica de la interfaz y evita agregar dependencias.

## 4. Cómo ejecutar la app

```bash
# 1. Clonar el repositorio
git clone [(https://github.com/1225100360admp-byte/spectrum.git)]
cd spectrum

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar en emulador o dispositivo conectado
flutter run
```

**Requisitos:** Flutter SDK instalado (verifica con `flutter doctor`), y un emulador Android o un dispositivo físico con depuración USB activada.

**Cuentas de prueba:** 
cliente@spectrum.com password: Cliente1234
admin@spectrum.com password: Admin1234
operador@spectrum.com password: Operador1234

## 6. Screenshots

### Splashscreen
(<img width="575" height="1192" alt="01-splash" src="https://github.com/user-attachments/assets/8ccac50b-624b-4e50-a9b0-e99252f30fab" />
)

### Autenticación
(<img width="575" height="1192" alt="02-login" src="https://github.com/user-attachments/assets/e24ba17f-b044-4159-af5d-4416d7f6e3bc" />)

(<img width="575" height="1192" alt="03-registro" src="https://github.com/user-attachments/assets/1c813c9d-68b4-43a3-ae9e-4de4026354e0" />)

### Dashboards
(<img width="720" height="1488" alt="04-dashboard-admin" src="https://github.com/user-attachments/assets/f88defa1-041c-425e-95b0-4a36448ed552" />)

(<img width="575" height="1192" alt="05-dashboard-cliente" src="https://github.com/user-attachments/assets/1b92a861-8cfe-4f53-afbc-992cec275dca" />)

(<img width="720" height="1488" alt="06-dashboard-operador" src="https://github.com/user-attachments/assets/f2a9e0ad-84f5-4d3c-af36-0f5737c008fa" />)

### Listas
<img width="575" height="1192" alt="07-lista-principal" src="https://github.com/user-attachments/assets/38751d62-8cf3-420f-8cbd-4db8d7deb93e" />

<img width="575" height="1192" alt="08-lista-detalle" src="https://github.com/user-attachments/assets/2423aef9-b47e-45f5-a58e-aab889f7d39e" />

<img width="720" height="1488" alt="09-lista-vacia" src="https://github.com/user-attachments/assets/24ee4b74-130f-44ed-93dd-5dafb55232fe" />

<img width="720" height="1488" alt="15-lista-trivias-admin" src="https://github.com/user-attachments/assets/7d509476-12ce-4735-804c-33e14404158b" />

### Formularios
<img width="575" height="1192" alt="10-formulario" src="https://github.com/user-attachments/assets/44eae0bd-e242-4cb8-bf27-1c0dcc2d4f10" />

<img width="720" height="1488" alt="14-formulario-operador" src="https://github.com/user-attachments/assets/8ecf1c69-13b2-44dc-bae6-3060142e4bf6" />

<img width="720" height="1488" alt="13-formulario-admin" src="https://github.com/user-attachments/assets/2b7a8c17-4070-4afa-b8d5-d7681c625c21" />


### Evidencia funcional
<img width="575" height="1192" alt="12-navegacion" src="https://github.com/user-attachments/assets/180c3f93-e408-4c2c-b4c3-26e3501d6ae5" />

<img width="625" height="1244" alt="11-foto-equipo" src="https://github.com/user-attachments/assets/ad03178a-d44d-49b2-922a-679b68491be1" />

