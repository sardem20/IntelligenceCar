from models.veiculo import Veiculo

from repositories.veiculo_repository import (
    VeiculoRepository
)

from repositories.user_repository import (
    UserRepository
)


class VeiculoService:

    @staticmethod
    def criar_veiculo(
        usuario_id,
        marca,
        modelo,
        ano,
        placa,
        quilometragem
    ):

        usuario = UserRepository.get_by_id(
            usuario_id
        )

        if not usuario:

            raise ValueError(
                "Usuário não encontrado."
            )

        if not marca or not marca.strip():

            raise ValueError(
                "Marca é obrigatória."
            )

        if not modelo or not modelo.strip():

            raise ValueError(
                "Modelo é obrigatório."
            )

        if not placa or not placa.strip():

            raise ValueError(
                "Placa é obrigatória."
            )

        placa = placa.strip().upper()

        existente = (
            VeiculoRepository.get_by_placa(
                placa
            )
        )

        if existente:

            raise ValueError(
                "Esta placa já está cadastrada."
            )

        novo_veiculo = Veiculo(

            usuario_id=usuario_id,

            marca=marca.strip(),

            modelo=modelo.strip(),

            ano=ano,

            placa=placa,

            quilometragem=(
                quilometragem
                if quilometragem is not None
                else 0
            )
        )

        return VeiculoRepository.save(
            novo_veiculo
        )

    @staticmethod
    def listar_veiculos():

        veiculos = (
            VeiculoRepository.get_all()
        )

        return [
            veiculo.to_dict()
            for veiculo in veiculos
        ]

    @staticmethod
    def buscar_por_id(veiculo_id):

        veiculo = (
            VeiculoRepository.get_by_id(
                veiculo_id
            )
        )

        if not veiculo:

            return None

        return veiculo.to_dict()

    @staticmethod
    def deletar_veiculo(veiculo_id):

        veiculo = (
            VeiculoRepository.get_by_id(
                veiculo_id
            )
        )

        if not veiculo:

            raise ValueError(
                "Veículo não encontrado."
            )

        VeiculoRepository.delete(
            veiculo
        )

    @staticmethod
    def buscar_veiculos(
        marca=None,
        modelo=None,
        ordem='modelo_asc'
    ):

        ordens_permitidas = [
            'modelo_asc',
            'ano_asc',
            'ano_desc'
        ]

        if ordem not in ordens_permitidas:

            raise ValueError(
                "Ordem inválida."
            )

        resultado = (
            VeiculoRepository.buscar_veiculos(
                marca=marca,
                modelo=modelo,
                ordem=ordem
            )
        )

        return [
            dict(veiculo)
            for veiculo in resultado
        ]