from flask import Blueprint, jsonify, request
from services.denuncias.criar_denuncia_service import CriarDenunciaService
from services.denuncias.listar_denuncia_service import ListarDenunciaService
from services.denuncias.buscar_denuncia_service import BuscarDenunciaService
from services.denuncias.atualizar_denuncia_service import AtualizarDenunciaService
from services.denuncias.deletar_denuncia_service import DeletarDenunciaService
from services.denuncias.buscar_denuncias_service import BuscarDenunciasService
from services.denuncias.consultar_placa_service import ConsultarPlacaService

denuncia_blueprint = Blueprint("denuncia_controller", __name__)


@denuncia_blueprint.route("/denuncias", methods=["POST"])
def criar():
    data = request.get_json() or {}
    try:
        item = CriarDenunciaService().execute(
            data.get("usuario_id"), data.get("placa"), data.get("tipo"),
            data.get("descricao"), data.get("veiculo_id")
        )
        return jsonify(item.to_dict()), 201
    except (ValueError, TypeError) as e:
        return jsonify({"error": str(e)}), 400


@denuncia_blueprint.route("/denuncias", methods=["GET"])
def listar():
    return jsonify(ListarDenunciaService().execute()), 200


@denuncia_blueprint.route("/denuncias/<int:id>", methods=["GET"])
def buscar(id):
    item = BuscarDenunciaService().execute(id)
    if not item:
        return jsonify({"error": "Denúncia não encontrada."}), 404
    return jsonify(item), 200


@denuncia_blueprint.route("/denuncias/<int:id>", methods=["PUT"])
def atualizar(id):
    data = request.get_json() or {}
    try:
        item = AtualizarDenunciaService().execute(
            id, data.get("tipo"), data.get("descricao"), data.get("status")
        )
        return jsonify(item.to_dict()), 200
    except LookupError as e:
        return jsonify({"error": str(e)}), 404
    except (ValueError, TypeError) as e:
        return jsonify({"error": str(e)}), 400


@denuncia_blueprint.route("/denuncias/<int:id>", methods=["DELETE"])
def deletar(id):
    try:
        DeletarDenunciaService().execute(id)
        return jsonify({"message": "Denúncia deletada com sucesso."}), 200
    except LookupError as e:
        return jsonify({"error": str(e)}), 404


@denuncia_blueprint.route("/denuncias/busca", methods=["GET"])
def busca_avancada():
    try:
        resultado = BuscarDenunciasService().execute(
            request.args.get("tipo"),
            request.args.get("status"),
            request.args.get("placa"),
            request.args.get("ordem", "data_desc"),
        )
        return jsonify(resultado), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 400


@denuncia_blueprint.route("/denuncias/placa/<placa>", methods=["GET"])
def consultar_placa(placa):
    try:
        return jsonify(ConsultarPlacaService().execute(placa)), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 400
