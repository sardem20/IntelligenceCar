from models.documento import Documento

class BuscarDocumentoService:
    def execute(self, documento_id):
        item = Documento.buscar_por_id(documento_id)
        return item.to_dict() if item else None
