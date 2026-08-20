from app import db


class Manutencao(db.Model):

    __tablename__ = "manutencoes"

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

    descricao = db.Column(
        db.Text
    )

    data_manutencao = db.Column(
        db.Date,
        nullable=False
    )

    quilometragem = db.Column(
        db.Integer,
        nullable=False
    )

    valor = db.Column(
        db.Numeric(10, 2),
        default=0
    )

    @classmethod
    def criar(
        cls,
        veiculo_id,
        tipo,
        descricao,
        data_manutencao,
        quilometragem,
        valor
    ):

        manutencao = cls(
            veiculo_id=veiculo_id,
            tipo=tipo,
            descricao=descricao,
            data_manutencao=data_manutencao,
            quilometragem=quilometragem,
            valor=valor
        )

        db.session.add(manutencao)

        db.session.commit()

        return manutencao

    @classmethod
    def listar(cls):

        return cls.query.all()

    @classmethod
    def buscar_por_id(cls, manutencao_id):

        return db.session.get(
            cls,
            manutencao_id
        )

    def atualizar(
        self,
        tipo=None,
        descricao=None,
        data_manutencao=None,
        quilometragem=None,
        valor=None
    ):

        if tipo is not None:
            self.tipo = tipo

        if descricao is not None:
            self.descricao = descricao

        if data_manutencao is not None:
            self.data_manutencao = data_manutencao

        if quilometragem is not None:
            self.quilometragem = quilometragem

        if valor is not None:
            self.valor = valor

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
            "descricao": self.descricao,
            "data_manutencao": (
                self.data_manutencao.isoformat()
                if self.data_manutencao
                else None
            ),
            "quilometragem": self.quilometragem,
            "valor": (
                float(self.valor)
                if self.valor is not None
                else 0
            )
        }