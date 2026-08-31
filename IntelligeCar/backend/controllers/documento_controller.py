from flask import Blueprint, jsonify, request
from services.documentos.criar_documento_service import CriarDocumentoService
from services.documentos.listar_documentos_service import ListarDocumentosService
from services.documentos.buscar_documento_service import BuscarDocumentoService
from services.documentos.atualizar_documento_service import AtualizarDocumentoService
from services.documentos.deletar_documento_service import DeletarDocumentoService
from services.documentos.documentos_proximos_vencimento_service import DocumentosProximosVencimentoService

documento_blueprint = Blueprint("documento_controller", __name__)

@documento_blueprint.route("/documentos", methods=["POST"])
def criar():
    data = request.get_json() or {}
    try:
        item = CriarDocumentoService().execute(
            data.get("veiculo_id"), data.get("tipo"),
            data.get("data_emissao"), data.get("data_validade")
        )
        return jsonify(item.to_dict()), 201
    except (ValueError, TypeError) as e:
        return jsonify({"error": str(e)}), 400

@documento_blueprint.route("/documentos", methods=["GET"])
def listar():
    return jsonify(ListarDocumentosService().execute()), 200

@documento_blueprint.route("/documentos/<int:id>", methods=["GET"])
def buscar(id):
    item = BuscarDocumentoService().execute(id)
    if not item:
        return jsonify({"error": "Documento não encontrado."}), 404
    return jsonify(item), 200

@documento_blueprint.route("/documentos/<int:id>", methods=["PUT"])
def atualizar(id):
    data = request.get_json() or {}
    try:
        item = AtualizarDocumentoService().execute(
            id, data.get("tipo"), data.get("data_emissao"), data.get("data_validade")
        )
        return jsonify(item.to_dict()), 200
    except (ValueError, TypeError) as e:
        return jsonify({"error": str(e)}), 400

@documento_blueprint.route("/documentos/<int:id>", methods=["DELETE"])
def deletar(id):
    try:
        DeletarDocumentoService().execute(id)
        return jsonify({"message": "Documento deletado com sucesso."}), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 404

@documento_blueprint.route("/documentos/proximos-vencimentos", methods=["GET"])
def proximos_vencimentos():
    return jsonify(DocumentosProximosVencimentoService().execute()), 200
