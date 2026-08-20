from flask import Blueprint, request, jsonify

from services.veiculos.criar_veiculo_service import (
    CriarVeiculoService
)

from services.veiculos.listar_veiculos_service import (
    ListarVeiculosService
)

from services.veiculos.buscar_veiculo_service import (
    BuscarVeiculoService
)

from services.veiculos.atualizar_veiculo_service import (
    AtualizarVeiculoService
)

from services.veiculos.deletar_veiculo_service import (
    DeletarVeiculoService
)

from services.veiculos.buscar_veiculos_service import (
    BuscarVeiculosService
)


veiculo_blueprint = Blueprint(
    "veiculo_controller",
    __name__
)


@veiculo_blueprint.route(
    "/veiculos",
    methods=["POST"]
)
def criar():

    data = request.get_json()

    try:

        service = CriarVeiculoService()

        veiculo = service.execute(
            data.get("usuario_id"),
            data.get("marca"),
            data.get("modelo"),
            data.get("ano"),
            data.get("placa"),
            data.get("quilometragem", 0)
        )

        return jsonify(
            veiculo.to_dict()
        ), 201

    except ValueError as e:

        return jsonify({
            "error": str(e)
        }), 400


@veiculo_blueprint.route(
    "/veiculos",
    methods=["GET"]
)
def listar():

    service = ListarVeiculosService()

    return jsonify(
        service.execute()
    ), 200


@veiculo_blueprint.route(
    "/veiculos/<int:id>",
    methods=["GET"]
)
def buscar(id):

    service = BuscarVeiculoService()

    veiculo = service.execute(id)

    if not veiculo:

        return jsonify({
            "error": "Veículo não encontrado."
        }), 404

    return jsonify(veiculo), 200


@veiculo_blueprint.route(
    "/veiculos/<int:id>",
    methods=["PUT"]
)
def atualizar(id):

    data = request.get_json()

    try:

        service = AtualizarVeiculoService()

        veiculo = service.execute(
            id,
            data.get("marca"),
            data.get("modelo"),
            data.get("ano"),
            data.get("placa"),
            data.get("quilometragem")
        )

        return jsonify(
            veiculo.to_dict()
        ), 200

    except ValueError as e:

        return jsonify({
            "error": str(e)
        }), 404


@veiculo_blueprint.route(
    "/veiculos/<int:id>",
    methods=["DELETE"]
)
def deletar(id):

    try:

        service = DeletarVeiculoService()

        service.execute(id)

        return jsonify({
            "message":
            "Veículo deletado com sucesso."
        }), 200

    except ValueError as e:

        return jsonify({
            "error": str(e)
        }), 404


@veiculo_blueprint.route(
    "/veiculos/busca",
    methods=["GET"]
)
def busca_avancada():

    marca = request.args.get("marca")

    modelo = request.args.get("modelo")

    ordem = request.args.get(
        "ordem",
        "modelo_asc"
    )

    try:

        service = BuscarVeiculosService()

        resultado = service.execute(
            marca,
            modelo,
            ordem
        )

        return jsonify(
            resultado
        ), 200

    except ValueError as e:

        return jsonify({
            "error": str(e)
        }), 400