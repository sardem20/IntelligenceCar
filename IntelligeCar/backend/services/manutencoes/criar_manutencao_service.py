from datetime import date
from models.manutencao import Manutencao
from models.veiculo import Veiculo

class CriarManutencaoService:
    def execute(self, veiculo_id, tipo, descricao, data_manutencao, quilometragem, valor=0):
        if not Veiculo.buscar_por_id(veiculo_id):
            raise ValueError("Veículo não encontrado.")
        if not tipo or not tipo.strip():
            raise ValueError("Tipo é obrigatório.")
        data = date.fromisoformat(data_manutencao)
        return Manutencao.criar(veiculo_id, tipo.strip(), descricao, data, quilometragem, valor or 0)
