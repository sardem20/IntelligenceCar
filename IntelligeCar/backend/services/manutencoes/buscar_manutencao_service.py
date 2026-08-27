from models.manutencao import Manutencao

class BuscarManutencaoService:
    def execute(self, manutencao_id):
        item = Manutencao.buscar_por_id(manutencao_id)
        return item.to_dict() if item else None
