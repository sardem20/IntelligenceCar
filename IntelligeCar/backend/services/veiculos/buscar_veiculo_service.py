from models.veiculo import Veiculo

class BuscarVeiculoService:
    def execute(self, veiculo_id):
        veiculo = Veiculo.buscar_por_id(veiculo_id)
        return veiculo.to_dict() if veiculo else None
