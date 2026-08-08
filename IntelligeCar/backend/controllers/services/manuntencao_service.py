from repositories.manutencao_repository import (
    ManutencaoRepository
)


class ManutencaoService:

    @staticmethod
    def historico_por_veiculo(
        veiculo_id
    ):

        resultado = (
            ManutencaoRepository
            .historico_por_veiculo(
                veiculo_id
            )
        )

        return [
            dict(manutencao)
            for manutencao in resultado
        ]