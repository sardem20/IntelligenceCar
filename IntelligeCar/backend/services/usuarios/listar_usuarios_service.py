from models.user import Usuario

class ListarUsuariosService:
    def execute(self):
        return [usuario.to_dict() for usuario in Usuario.listar()]
