from flask import Blueprint, jsonify

from services.documentos.documentos_proximos_vencimento_service import (
    DocumentosProximosVencimentoService
)


documento_blueprint = Blueprint(
    "documento_controller",
    __name__
)


@documento_blueprint.route(
    "/documentos/proximos-vencimentos",
    methods=["GET"]
)
def proximos_vencimentos():

    service = (
        DocumentosProximosVencimentoService()
    )

    resultado = service.execute()

    return jsonify(
        resultado
    ), 200