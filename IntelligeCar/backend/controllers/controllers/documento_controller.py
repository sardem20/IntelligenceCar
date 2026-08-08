from flask import Blueprint, jsonify

from services.documento_service import (
    DocumentoService
)


documento_blueprint = Blueprint(
    'documento_controller',
    __name__
)


@documento_blueprint.route(
    '/documentos/proximos-vencimentos',
    methods=['GET']
)
def proximos_vencimentos():

    documentos = (
        DocumentoService
        .proximos_vencimentos()
    )

    return jsonify(
        documentos
    ), 200