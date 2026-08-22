from models.user import Usuario


class ListarUsuariosService:

    def execute(self):

        usuarios = Usuario.listar()

        return [
            usuario.to_dict()
            for usuario in usuarios
        ]