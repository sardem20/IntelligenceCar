from models.denuncia import Denuncia


class DeletarDenunciaService:
    def execute(self, denuncia_id):
        item = Denuncia.buscar_por_id(denuncia_id)
        if not item:
            raise LookupError("Denúncia não encontrada.")
        item.deletar()
        return True
