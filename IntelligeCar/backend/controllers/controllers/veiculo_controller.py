from flask import Blueprint, request, jsonify

from services.veiculo_service import (
    VeiculoService
)


veiculo_blueprint = Blueprint(
    'veiculo_controller',
    __name__
)


@veiculo_blueprint.route(
    '/veiculos',
    methods=['POST']
)
def criar():

    data = request.get_json()

    if not data:

        return jsonify({
            "error": "JSON não enviado."
        }), 400

    try:

        veiculo = (
            VeiculoService.criar_veiculo(
                data.get('usuario_id'),
                data.get('marca'),
                data.get('modelo'),
                data.get('ano'),
                data.get('placa'),
                data.get('quilometragem', 0)
            )
        )

        return jsonify(
            veiculo.to_dict()
        ), 201

    except ValueError as e:

        return jsonify({
            "error": str(e)
        }), 400


@veiculo_blueprint.route(
    '/veiculos',
    methods=['GET']
)
def listar():

    veiculos = (
        VeiculoService.listar_veiculos()
    )

    return jsonify(veiculos), 200


@veiculo_blueprint.route(
    '/veiculos/<int:id>',
    methods=['GET']
)
def buscar(id):

    veiculo = (
        VeiculoService.buscar_por_id(id)
    )

    if not veiculo:

        return jsonify({
            "error":
            "Veículo não encontrado."
        }), 404

    return jsonify(veiculo), 200


@veiculo_blueprint.route(
    '/veiculos/<int:id>',
    methods=['DELETE']
)
def deletar(id):

    try:

        VeiculoService.deletar_veiculo(id)

        return jsonify({
            "message":
            "Veículo deletado com sucesso."
        }), 200

    except ValueError as e:

        return jsonify({
            "error": str(e)
        }), 404


@veiculo_blueprint.route(
    '/veiculos/buscar',
    methods=['GET']
)
def buscar_veiculos():

    marca = request.args.get(
        'marca'
    )

    modelo = request.args.get(
        'modelo'
    )

    ordem = request.args.get(
        'ordem',
        'modelo_asc'
    )

    try:

        veiculos = (
            VeiculoService.buscar_veiculos(
                marca=marca,
                modelo=modelo,
                ordem=ordem
            )
        )

        return jsonify(veiculos), 200

    except ValueError as e:

        return jsonify({
            "error": str(e)
        }), 400