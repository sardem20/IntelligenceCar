from models.user import Usuario

class AtualizarUsuarioService:
    def execute(self, user_id, nome=None, email=None):
        usuario = Usuario.buscar_por_id(user_id)
        if not usuario:
            raise ValueError("Usuário não encontrado.")
        if nome is not None and not nome.strip():
            raise ValueError("Nome é obrigatório.")
        if email is not None and not email.strip():
            raise ValueError("Email é obrigatório.")
        return usuario.atualizar(
            nome=nome.strip() if nome is not None else None,
            email=email.strip().lower() if email is not None else None
        )
