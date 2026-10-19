from models.denuncia import Denuncia


class BuscarDenunciaService:
    def execute(self, denuncia_id):
        item = Denuncia.buscar_por_id(denuncia_id)
        return item.to_dict() if item else None
