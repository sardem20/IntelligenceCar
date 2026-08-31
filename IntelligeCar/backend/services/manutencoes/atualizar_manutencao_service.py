from datetime import date
from models.manutencao import Manutencao

class AtualizarManutencaoService:
    def execute(self, manutencao_id, tipo=None, descricao=None, data_manutencao=None, quilometragem=None, valor=None):
        item = Manutencao.buscar_por_id(manutencao_id)
        if not item:
            raise ValueError("Manutenção não encontrada.")
        data = date.fromisoformat(data_manutencao) if data_manutencao else None
        return item.atualizar(tipo, descricao, data, quilometragem, valor)
