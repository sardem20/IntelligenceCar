from models.user import Usuario


class AtualizarUsuarioService:

    def execute(
        self,
        user_id,
        nome=None,
        email=None
    ):

        usuario = Usuario.buscar_por_id(
            user_id
        )

        if not usuario:

            raise ValueError(
                "Usuário não encontrado."
            )

        usuario.atualizar(
            nome=nome,
            email=email
        )

        return usuario