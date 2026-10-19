from datetime import datetime
from extensions import db


class Denuncia(db.Model):
    __tablename__ = "denuncias"

    TIPOS = (
        "GOLPE_ANUNCIO_FALSO",
        "PAGAMENTO_ANTECIPADO",
        "CLONAGEM_VEICULO",
        "DOCUMENTO_FALSO",
        "ADULTERACAO_KM",
        "VEICULO_ROUBADO",
        "OUTRO",
    )
    STATUS = ("PENDENTE", "EM_ANALISE", "PROCEDENTE", "IMPROCEDENTE")

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey("usuarios.id"), nullable=False)
    veiculo_id = db.Column(db.Integer, db.ForeignKey("veiculos.id"), nullable=True)
    placa = db.Column(db.String(10), nullable=False, index=True)
    tipo = db.Column(db.String(30), nullable=False)
    descricao = db.Column(db.Text, nullable=False)
    status = db.Column(db.String(20), nullable=False, default="PENDENTE")
    data_criacao = db.Column(db.DateTime, nullable=False, default=datetime.now)

    @classmethod
    def criar(cls, usuario_id, placa, tipo, descricao, veiculo_id=None):
        denuncia = cls(
            usuario_id=usuario_id,
            veiculo_id=veiculo_id,
            placa=placa,
            tipo=tipo,
            descricao=descricao,
            status="PENDENTE",
        )
        db.session.add(denuncia)
        db.session.commit()
        return denuncia

    @classmethod
    def listar(cls):
        return cls.query.order_by(cls.data_criacao.desc()).all()

    @classmethod
    def buscar_por_id(cls, denuncia_id):
        return db.session.get(cls, denuncia_id)

    def atualizar(self, tipo=None, descricao=None, status=None):
        if tipo is not None:
            self.tipo = tipo
        if descricao is not None:
            self.descricao = descricao
        if status is not None:
            self.status = status
        db.session.commit()
        return self

    def deletar(self):
        db.session.delete(self)
        db.session.commit()

    def to_dict(self):
        return {
            "id": self.id,
            "usuario_id": self.usuario_id,
            "veiculo_id": self.veiculo_id,
            "placa": self.placa,
            "tipo": self.tipo,
            "descricao": self.descricao,
            "status": self.status,
            "data_criacao": self.data_criacao.isoformat() if self.data_criacao else None,
        }
