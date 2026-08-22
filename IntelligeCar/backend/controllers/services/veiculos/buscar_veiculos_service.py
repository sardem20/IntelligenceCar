from repositories.veiculo_repository import (
    VeiculoRepository
)


class BuscarVeiculosService:

    def execute(
        self,
        marca=None,
        modelo=None,
        ordem="modelo_asc"
    ):

        ordens_permitidas = [
            "modelo_asc",
            "ano_asc",
            "ano_desc"
        ]

        if ordem not in ordens_permitidas:

            raise ValueError(
                "Ordem inválida."
            )

        resultado = (
            VeiculoRepository.buscar_veiculos(
                marca,
                modelo,
                ordem
            )
        )

        return [
            dict(item)
            for item in resultado
        ]