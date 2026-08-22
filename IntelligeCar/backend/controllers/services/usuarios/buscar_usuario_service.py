from models.user import Usuario


class BuscarUsuarioService:

    def execute(self, user_id):

        usuario = Usuario.buscar_por_id(
            user_id
        )

        if not usuario:
            return None

        return usuario.to_dict()