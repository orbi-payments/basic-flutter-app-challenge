# Flutter User Management App

Este es un ejemplo de una aplicación Flutter para la gestión de usuarios. La aplicación permite a los usuarios iniciar sesión, ver una lista de usuarios, crear nuevos usuarios, editar usuarios existentes y eliminar usuarios. La aplicación está diseñada para funcionar con una API de backend que gestiona los datos de los usuarios.

## Características

- **Inicio de sesión**: Los usuarios pueden iniciar sesión con un nombre de usuario y contraseña.
- **Lista de usuarios**: Muestra una lista de todos los usuarios registrados.
- **Crear usuario**: Permite crear un nuevo usuario proporcionando nombre, correo electrónico y edad.
- **Editar usuario**: Permite modificar los detalles de un usuario existente.
- **Eliminar usuario**: Permite eliminar un usuario de la lista.

### Screenshots

[Agregar screenshots aqui]

## Tecnologías Utilizadas

- **Flutter**: Framework de UI para aplicaciones móviles.
- **Dio**: Paquete para hacer solicitudes HTTP.
- **Selenium**: Preparado para pruebas automatizadas con claves de identificación (`Key`) en la interfaz de usuario.

## Instalación

Sigue estos pasos para configurar y ejecutar la aplicación en tu entorno local:

### Requisitos Previos

- [Flutter](https://flutter.dev/docs/get-started/install): Asegúrate de tener Flutter instalado en tu máquina.
- [Dart](https://dart.dev/get-dart): Dart SDK está incluido con Flutter.
- Acceso a una API que maneje los usuarios. Asegúrate de configurar la URL de la API en `ApiService`.

### Configuración

1. **Clonar el repositorio**:

   ```bash
   git clone https://github.com/orbi-payments/basic-flutter-app-challenge.git
   cd flutter-user-management-app
   ```

2. **Instalar dependencias**:

   Ejecuta el siguiente comando en la raíz del proyecto para instalar las dependencias de Flutter:

   ```bash
   flutter pub get
   ```

3. **Configuración de la API**:

   Asegúrate de que la URL base de la API esté correctamente configurada en el archivo `lib/services/api/api_service.dart`:

   ```dart
   _dio.options.baseUrl = 'https://tu-api-url.com';
   ```

### Ejecución

1. **Ejecutar la aplicación en un emulador o dispositivo físico**:

   ```bash
   flutter run
   ```

   Esto iniciará la aplicación en el emulador o dispositivo conectado.

### Estructura del Proyecto

- **lib/**
  - **services/**: Contiene la lógica de la API y los modelos de datos.
  - **screens/**: Contiene las pantallas principales de la aplicación (Login, Users List, User Detail, New User).
  - **main.dart**: El punto de entrada de la aplicación.

### Pruebas Automatizadas

La aplicación está preparada para pruebas automatizadas utilizando Selenium. Las claves de identificación (`Key`) están configuradas en los elementos de la interfaz para facilitar las pruebas.

## Contribuciones

Las contribuciones son bienvenidas. Si deseas mejorar algo o agregar nuevas características, sigue estos pasos:

1. Haz un fork del proyecto.
2. Crea una nueva rama (`git checkout -b feature-nueva-caracteristica`).
3. Realiza los cambios y haz commit (`git commit -am 'Agrega una nueva característica'`).
4. Haz push a la rama (`git push origin feature-nueva-caracteristica`).
5. Abre un Pull Request.