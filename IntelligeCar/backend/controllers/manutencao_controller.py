from flask import Blueprint, jsonify, request
from services.manutencoes.criar_manutencao_service import CriarManutencaoService
from services.manutencoes.listar_manutencoes_service import ListarManutencoesService
from services.manutencoes.buscar_manutencao_service import BuscarManutencaoService
from services.manutencoes.atualizar_manutencao_service import AtualizarManutencaoService
from services.manutencoes.deletar_manutencao_service import DeletarManutencaoService
from services.manutencoes.historico_manutencoes_service import HistoricoManutencoesService

manutencao_blueprint = Blueprint("manutencao_controller", __name__)

@manutencao_blueprint.route("/manutencoes", methods=["POST"])
def criar():
    data = request.get_json() or {}
    try:
        item = CriarManutencaoService().execute(
            data.get("veiculo_id"), data.get("tipo"), data.get("descricao"),
            data.get("data_manutencao"), data.get("quilometragem"), data.get("valor", 0)
        )
        return jsonify(item.to_dict()), 201
    except (ValueError, TypeError) as e:
        return jsonify({"error": str(e)}), 400

@manutencao_blueprint.route("/manutencoes", methods=["GET"])
def listar():
    return jsonify(ListarManutencoesService().execute()), 200

@manutencao_blueprint.route("/manutencoes/<int:id>", methods=["GET"])
def buscar(id):
    item = BuscarManutencaoService().execute(id)
    if not item:
        return jsonify({"error": "Manutenção não encontrada."}), 404
    return jsonify(item), 200

@manutencao_blueprint.route("/manutencoes/<int:id>", methods=["PUT"])
def atualizar(id):
    data = request.get_json() or {}
    try:
        item = AtualizarManutencaoService().execute(
            id, data.get("tipo"), data.get("descricao"),
            data.get("data_manutencao"), data.get("quilometragem"), data.get("valor")
        )
        return jsonify(item.to_dict()), 200
    except (ValueError, TypeError) as e:
        return jsonify({"error": str(e)}), 400

@manutencao_blueprint.route("/manutencoes/<int:id>", methods=["DELETE"])
def deletar(id):
    try:
        DeletarManutencaoService().execute(id)
        return jsonify({"message": "Manutenção deletada com sucesso."}), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 404

@manutencao_blueprint.route("/veiculos/<int:veiculo_id>/manutencoes", methods=["GET"])
def historico(veiculo_id):
    return jsonify(HistoricoManutencoesService().execute(veiculo_id)), 200
