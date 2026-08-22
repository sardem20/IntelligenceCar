from app import db


class Usuario(db.Model):

    __tablename__ = "usuarios"

    id = db.Column(
        db.Integer,
        primary_key=True,
        autoincrement=True
    )

    nome = db.Column(
        db.String(100),
        nullable=False
    )

    email = db.Column(
        db.String(100),
        nullable=False,
        unique=True
    )

    veiculos = db.relationship(
        "Veiculo",
        backref="proprietario",
        lazy=True,
        cascade="all, delete-orphan"
    )

    # =====================================
    # CREATE
    # =====================================

    @classmethod
    def criar(cls, nome, email):

        usuario = cls(
            nome=nome,
            email=email
        )

        db.session.add(usuario)
        db.session.commit()

        return usuario

    # =====================================
    # READ
    # =====================================

    @classmethod
    def listar(cls):

        return cls.query.all()

    @classmethod
    def buscar_por_id(cls, user_id):

        return db.session.get(
            cls,
            user_id
        )

    # =====================================
    # UPDATE
    # =====================================

    def atualizar(
        self,
        nome=None,
        email=None
    ):

        if nome is not None:
            self.nome = nome

        if email is not None:
            self.email = email

        db.session.commit()

        return self

    # =====================================
    # DELETE
    # =====================================

    def deletar(self):

        db.session.delete(self)

        db.session.commit()

    # =====================================
    # JSON
    # =====================================

    def to_dict(self):

        return {
            "id": self.id,
            "nome": self.nome,
            "email": self.email
        }