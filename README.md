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
![Splash](screenshots/01-splash.png)

### Autenticación
![Login](screenshots/02-login.png)
![Registro](screenshots/03-registro.png)

### Dashboards
![Dashboard Admin](screenshots/04-dashboard-admin.png)
![Dashboard Cliente](screenshots/05-dashboard-cliente.png)
![Dashboard Operador](screenshots/06-dashboard-operador.png)

### Listas
![Lista principal](screenshots/07-lista-principal.png)
![Lista detalle](screenshots/08-lista-detalle.png)
![Estado vacío](screenshots/09-lista-vacia.png)
![Lista Administrador: trivias publicadas](screenshots/15-lista-trivias-admin.png)

### Formularios
![Formulario dominio (Cliente: preferencias musicales)](screenshots/10-formulario.png)
![Formulario Administrador: nueva trivia](screenshots/13-formulario-admin.png)
![Formulario Operador: revisar reporte](screenshots/14-formulario-operador.png)

### Evidencia funcional
![Foto equipo](screenshots/11-foto-equipo.png)
![Navegación](screenshots/12-navegacion.png)
