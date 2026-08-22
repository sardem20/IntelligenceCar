from models.veiculo import Veiculo


class ListarVeiculosService:

    def execute(self):

        veiculos = Veiculo.listar()

        return [
            veiculo.to_dict()
            for veiculo in veiculos
        ]