from flask import Blueprint, request, jsonify

from services.user_service import UserService


user_blueprint = Blueprint(
    'user_controller',
    __name__
)


# ==========================================
# CRUD
# ==========================================

@user_blueprint.route(
    '/usuarios',
    methods=['POST']
)
def criar():

    data = request.get_json()

    if not data:
        return jsonify({
            "error": "JSON não enviado."
        }), 400

    try:

        novo_usuario = UserService.criar_usuario(
            data.get('nome'),
            data.get('email')
        )

        return jsonify(
            novo_usuario.to_dict()
        ), 201

    except ValueError as e:

        return jsonify({
            "error": str(e)
        }), 400


@user_blueprint.route(
    '/usuarios',
    methods=['GET']
)
def listar():

    usuarios = UserService.listar_usuarios()

    return jsonify(usuarios), 200


@user_blueprint.route(
    '/usuarios/<int:id>',
    methods=['GET']
)
def buscar(id):

    usuario = UserService.buscar_por_id(id)

    if not usuario:

        return jsonify({
            "error": "Usuário não encontrado."
        }), 404

    return jsonify(usuario), 200


@user_blueprint.route(
    '/usuarios/<int:id>',
    methods=['PUT']
)
def atualizar(id):

    data = request.get_json()

    if not data:

        return jsonify({
            "error": "JSON não enviado."
        }), 400

    try:

        usuario_atualizado = UserService.atualizar_usuario(
            id,
            data.get('nome'),
            data.get('email')
        )

        return jsonify(
            usuario_atualizado.to_dict()
        ), 200

    except ValueError as e:

        return jsonify({
            "error": str(e)
        }), 400


@user_blueprint.route(
    '/usuarios/<int:id>',
    methods=['DELETE']
)
def deletar(id):

    try:

        UserService.deletar_usuario(id)

        return jsonify({
            "message": "Usuário deletado com sucesso."
        }), 200

    except ValueError as e:

        return jsonify({
            "error": str(e)
        }), 404


# ==========================================
# NOVA FUNCIONALIDADE
# BUSCA, FILTRO E ORDENAÇÃO
# ==========================================

@user_blueprint.route(
    '/usuarios/buscar',
    methods=['GET']
)
def buscar_usuarios():

    nome = request.args.get('nome')
    email = request.args.get('email')
    ordem = request.args.get(
        'ordem',
        'nome_asc'
    )

    try:

        usuarios = UserService.buscar_usuarios(
            nome=nome,
            email=email,
            ordem=ordem
        )

        return jsonify(usuarios), 200

    except ValueError as e:

        return jsonify({
            "error": str(e)
        }), 400