from models.manutencao import Manutencao

class DeletarManutencaoService:
    def execute(self, manutencao_id):
        item = Manutencao.buscar_por_id(manutencao_id)
        if not item:
            raise ValueError("Manutenção não encontrada.")
        item.deletar()
        return True
