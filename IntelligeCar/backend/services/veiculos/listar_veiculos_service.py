from models.veiculo import Veiculo

class ListarVeiculosService:
    def execute(self):
        return [veiculo.to_dict() for veiculo in Veiculo.listar()]
