from flask import Blueprint, jsonify, request
from services.usuarios.criar_usuario_service import CriarUsuarioService
from services.usuarios.listar_usuarios_service import ListarUsuariosService
from services.usuarios.buscar_usuario_service import BuscarUsuarioService
from services.usuarios.atualizar_usuario_service import AtualizarUsuarioService
from services.usuarios.deletar_usuario_service import DeletarUsuarioService
from services.usuarios.login_service import LoginService

user_blueprint = Blueprint("user_controller", __name__)

@user_blueprint.route("/usuarios", methods=["POST"])
def criar():
    data = request.get_json() or {}
    try:
        usuario = CriarUsuarioService().execute(
            data.get("nome"), data.get("email"),
            data.get("telefone"), data.get("senha_hash")
        )
        return jsonify(usuario.to_dict()), 201
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
        usuario = AtualizarUsuarioService().execute(
            id, data.get("nome"), data.get("email"), data.get("telefone"),
            data.get("senha_atual"), data.get("nova_senha")
        )
        return jsonify(usuario.to_dict()), 200
    except LookupError as e:
        return jsonify({"error": str(e)}), 404
    except ValueError as e:
        return jsonify({"error": str(e)}), 400

@user_blueprint.route("/usuarios/<int:id>", methods=["DELETE"])
def deletar(id):
    try:
        DeletarUsuarioService().execute(id)
        return jsonify({"message": "Usuário deletado com sucesso."}), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 404

@user_blueprint.route("/login", methods=["POST"])
def login():
    data = request.get_json() or {}
    try:
        usuario = LoginService().execute(data.get("email"), data.get("senha"))
        return jsonify(usuario.to_dict()), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 400
    except PermissionError as e:
        return jsonify({"error": str(e)}), 401
