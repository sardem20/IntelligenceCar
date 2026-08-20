from app import db


class Documento(db.Model):

    __tablename__ = "documentos"

    id = db.Column(
        db.Integer,
        primary_key=True,
        autoincrement=True
    )

    veiculo_id = db.Column(
        db.Integer,
        db.ForeignKey("veiculos.id"),
        nullable=False
    )

    tipo = db.Column(
        db.String(100),
        nullable=False
    )

    data_emissao = db.Column(
        db.Date
    )

    data_validade = db.Column(
        db.Date,
        nullable=False
    )

    @classmethod
    def criar(
        cls,
        veiculo_id,
        tipo,
        data_emissao,
        data_validade
    ):

        documento = cls(
            veiculo_id=veiculo_id,
            tipo=tipo,
            data_emissao=data_emissao,
            data_validade=data_validade
        )

        db.session.add(documento)

        db.session.commit()

        return documento

    @classmethod
    def listar(cls):

        return cls.query.all()

    @classmethod
    def buscar_por_id(cls, documento_id):

        return db.session.get(
            cls,
            documento_id
        )

    def atualizar(
        self,
        tipo=None,
        data_emissao=None,
        data_validade=None
    ):

        if tipo is not None:
            self.tipo = tipo

        if data_emissao is not None:
            self.data_emissao = data_emissao

        if data_validade is not None:
            self.data_validade = data_validade

        db.session.commit()

        return self

    def deletar(self):

        db.session.delete(self)

        db.session.commit()

    def to_dict(self):

        return {
            "id": self.id,
            "veiculo_id": self.veiculo_id,
            "tipo": self.tipo,
            "data_emissao": (
                self.data_emissao.isoformat()
                if self.data_emissao
                else None
            ),
            "data_validade": (
                self.data_validade.isoformat()
                if self.data_validade
                else None
            )
        }