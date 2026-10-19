from models.denuncia import Denuncia


class ListarDenunciaService:
    def execute(self):
        return [item.to_dict() for item in Denuncia.listar()]
