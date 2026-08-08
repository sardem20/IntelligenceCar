from flask import Blueprint, jsonify

from services.manutencao_service import (
    ManutencaoService
)


manutencao_blueprint = Blueprint(
    'manutencao_controller',
    __name__
)


@manutencao_blueprint.route(
    '/veiculos/<int:veiculo_id>/manutencoes',
    methods=['GET']
)
def historico(veiculo_id):

    manutencoes = (
        ManutencaoService
        .historico_por_veiculo(
            veiculo_id
        )
    )

    return jsonify(
        manutencoes
    ), 200