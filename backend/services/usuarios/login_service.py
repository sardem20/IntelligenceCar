from models.user import Usuario

class LoginService:
    def execute(self, email, senha):
        if not email or not senha:
            raise ValueError("Informe e-mail e senha.")
        usuario = Usuario.buscar_por_email(email.strip().lower())
        # Mesma mensagem para e-mail inexistente e senha errada (não revela quais e-mails existem).
        if not usuario or not usuario.verificar_senha(senha):
            raise PermissionError("E-mail ou senha inválidos.")
        return usuario
