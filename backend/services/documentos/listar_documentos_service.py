from models.documento import Documento

class ListarDocumentosService:
    def execute(self):
        return [item.to_dict() for item in Documento.listar()]
