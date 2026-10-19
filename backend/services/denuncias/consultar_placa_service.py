from repositories.denuncia_repository import DenunciaRepository
from services.denuncias.validacao import normalizar_placa


class ConsultarPlacaService:
    """Resumo de denúncias de uma placa — útil para checar antes de comprar um veículo."""

    def execute(self, placa):
        placa = normalizar_placa(placa)
        resumo = dict(DenunciaRepository.consultar_placa(placa))
        if resumo.get("ultima_denuncia"):
            resumo["ultima_denuncia"] = resumo["ultima_denuncia"].isoformat()
        for chave in ("total", "confirmadas", "em_analise", "pendentes"):
            resumo[chave] = int(resumo.get(chave) or 0)
        return resumo
