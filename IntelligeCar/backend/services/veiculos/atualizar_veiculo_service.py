from models.veiculo import Veiculo

class AtualizarVeiculoService:
    def execute(self, veiculo_id, marca=None, modelo=None, ano=None, placa=None, quilometragem=None):
        veiculo = Veiculo.buscar_por_id(veiculo_id)
        if not veiculo:
            raise ValueError("Veículo não encontrado.")
        return veiculo.atualizar(marca, modelo, ano, placa, quilometragem)
