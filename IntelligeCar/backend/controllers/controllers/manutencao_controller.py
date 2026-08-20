from flask import Blueprint, jsonify

from services.manutencoes.historico_manutencoes_service import (
    HistoricoManutencoesService
)


manutencao_blueprint = Blueprint(
    "manutencao_controller",
    __name__
)


@manutencao_blueprint.route(
    "/veiculos/<int:veiculo_id>/manutencoes",
    methods=["GET"]
)
def historico(veiculo_id):

    service = HistoricoManutencoesService()

    resultado = service.execute(
        veiculo_id
    )

    return jsonify(
        resultado
    ), 200