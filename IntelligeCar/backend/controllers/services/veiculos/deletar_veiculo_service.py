from models.veiculo import Veiculo


class DeletarVeiculoService:

    def execute(self, veiculo_id):

        veiculo = Veiculo.buscar_por_id(
            veiculo_id
        )

        if not veiculo:

            raise ValueError(
                "Veículo não encontrado."
            )

        veiculo.deletar()

        return True