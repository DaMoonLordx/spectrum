/// El orden del enum define el orden de las pestañas del dashboard.
enum UserRole {
  admin,
  cliente,
  operador;

  String get label => switch (this) {
        UserRole.admin => 'Administrador',
        UserRole.cliente => 'Cliente',
        UserRole.operador => 'Operador',
      };

  String get description => switch (this) {
        UserRole.admin => 'Gestiona usuarios y la plataforma',
        UserRole.cliente => 'Conecta con gente y juega',
        UserRole.operador => 'Modera reportes y contenido',
      };
}
