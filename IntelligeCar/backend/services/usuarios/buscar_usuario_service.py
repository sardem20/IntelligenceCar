from models.user import Usuario

class BuscarUsuarioService:
    def execute(self, user_id):
        usuario = Usuario.buscar_por_id(user_id)
        return usuario.to_dict() if usuario else None
