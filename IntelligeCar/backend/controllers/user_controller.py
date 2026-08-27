from flask import Blueprint, jsonify, request
from services.usuarios.criar_usuario_service import CriarUsuarioService
from services.usuarios.listar_usuarios_service import ListarUsuariosService
from services.usuarios.buscar_usuario_service import BuscarUsuarioService
from services.usuarios.atualizar_usuario_service import AtualizarUsuarioService
from services.usuarios.deletar_usuario_service import DeletarUsuarioService

user_blueprint = Blueprint("user_controller", __name__)

@user_blueprint.route("/usuarios", methods=["POST"])
def criar():
    data = request.get_json() or {}
    try:
        return jsonify(CriarUsuarioService().execute(data.get("nome"), data.get("email")).to_dict()), 201
    except ValueError as e:
        return jsonify({"error": str(e)}), 400

@user_blueprint.route("/usuarios", methods=["GET"])
def listar():
    return jsonify(ListarUsuariosService().execute()), 200

@user_blueprint.route("/usuarios/<int:id>", methods=["GET"])
def buscar(id):
    usuario = BuscarUsuarioService().execute(id)
    if not usuario:
        return jsonify({"error": "Usuário não encontrado."}), 404
    return jsonify(usuario), 200

@user_blueprint.route("/usuarios/<int:id>", methods=["PUT"])
def atualizar(id):
    data = request.get_json() or {}
    try:
        usuario = AtualizarUsuarioService().execute(id, data.get("nome"), data.get("email"))
        return jsonify(usuario.to_dict()), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 404

@user_blueprint.route("/usuarios/<int:id>", methods=["DELETE"])
def deletar(id):
    try:
        DeletarUsuarioService().execute(id)
        return jsonify({"message": "Usuário deletado com sucesso."}), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 404
