from models.user import Usuario


class DeletarUsuarioService:

    def execute(self, user_id):

        usuario = Usuario.buscar_por_id(
            user_id
        )

        if not usuario:

            raise ValueError(
                "Usuário não encontrado."
            )

        usuario.deletar()

        return True