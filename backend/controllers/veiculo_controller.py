from flask import Blueprint, jsonify, request
from services.veiculos.criar_veiculo_service import CriarVeiculoService
from services.veiculos.listar_veiculos_service import ListarVeiculosService
from services.veiculos.buscar_veiculo_service import BuscarVeiculoService
from services.veiculos.atualizar_veiculo_service import AtualizarVeiculoService
from services.veiculos.deletar_veiculo_service import DeletarVeiculoService
from services.veiculos.buscar_veiculos_service import BuscarVeiculosService

veiculo_blueprint = Blueprint("veiculo_controller", __name__)

@veiculo_blueprint.route("/veiculos", methods=["POST"])
def criar():
    data = request.get_json() or {}
    try:
        veiculo = CriarVeiculoService().execute(
            data.get("usuario_id"), data.get("marca"), data.get("modelo"),
            data.get("ano"), data.get("placa"), data.get("quilometragem", 0)
        )
        return jsonify(veiculo.to_dict()), 201
    except (ValueError, TypeError) as e:
        return jsonify({"error": str(e)}), 400

@veiculo_blueprint.route("/veiculos", methods=["GET"])
def listar():
    return jsonify(ListarVeiculosService().execute()), 200

@veiculo_blueprint.route("/veiculos/<int:id>", methods=["GET"])
def buscar(id):
    veiculo = BuscarVeiculoService().execute(id)
    if not veiculo:
        return jsonify({"error": "Veículo não encontrado."}), 404
    return jsonify(veiculo), 200

@veiculo_blueprint.route("/veiculos/<int:id>", methods=["PUT"])
def atualizar(id):
    data = request.get_json() or {}
    try:
        veiculo = AtualizarVeiculoService().execute(
            id, data.get("marca"), data.get("modelo"), data.get("ano"),
            data.get("placa"), data.get("quilometragem")
        )
        return jsonify(veiculo.to_dict()), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 404

@veiculo_blueprint.route("/veiculos/<int:id>", methods=["DELETE"])
def deletar(id):
    try:
        DeletarVeiculoService().execute(id)
        return jsonify({"message": "Veículo deletado com sucesso."}), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 404

@veiculo_blueprint.route("/veiculos/busca", methods=["GET"])
def busca_avancada():
    try:
        resultado = BuscarVeiculosService().execute(
            request.args.get("marca"),
            request.args.get("modelo"),
            request.args.get("ordem", "modelo_asc")
        )
        return jsonify(resultado), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 400
