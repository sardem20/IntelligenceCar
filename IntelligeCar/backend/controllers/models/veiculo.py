from app import db


class Veiculo(db.Model):

    __tablename__ = "veiculos"

    id = db.Column(
        db.Integer,
        primary_key=True,
        autoincrement=True
    )

    usuario_id = db.Column(
        db.Integer,
        db.ForeignKey("usuarios.id"),
        nullable=False
    )

    marca = db.Column(
        db.String(50),
        nullable=False
    )

    modelo = db.Column(
        db.String(100),
        nullable=False
    )

    ano = db.Column(
        db.Integer,
        nullable=False
    )

    placa = db.Column(
        db.String(10),
        nullable=False,
        unique=True
    )

    quilometragem = db.Column(
        db.Integer,
        nullable=False,
        default=0
    )

    @classmethod
    def criar(
        cls,
        usuario_id,
        marca,
        modelo,
        ano,
        placa,
        quilometragem=0
    ):

        veiculo = cls(
            usuario_id=usuario_id,
            marca=marca,
            modelo=modelo,
            ano=ano,
            placa=placa,
            quilometragem=quilometragem
        )

        db.session.add(veiculo)

        db.session.commit()

        return veiculo

    @classmethod
    def listar(cls):

        return cls.query.all()

    @classmethod
    def buscar_por_id(cls, veiculo_id):

        return db.session.get(
            cls,
            veiculo_id
        )

    def atualizar(
        self,
        marca=None,
        modelo=None,
        ano=None,
        placa=None,
        quilometragem=None
    ):

        if marca is not None:
            self.marca = marca

        if modelo is not None:
            self.modelo = modelo

        if ano is not None:
            self.ano = ano

        if placa is not None:
            self.placa = placa

        if quilometragem is not None:
            self.quilometragem = quilometragem

        db.session.commit()

        return self

    def deletar(self):

        db.session.delete(self)

        db.session.commit()

    def to_dict(self):

        return {
            "id": self.id,
            "usuario_id": self.usuario_id,
            "marca": self.marca,
            "modelo": self.modelo,
            "ano": self.ano,
            "placa": self.placa,
            "quilometragem": self.quilometragem
        }