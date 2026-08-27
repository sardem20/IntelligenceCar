import os
from dotenv import load_dotenv
from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy

load_dotenv()
db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    database_url = os.getenv("DATABASE_URL")
    if not database_url:
        raise RuntimeError("DATABASE_URL não foi configurada no arquivo .env")
    app.config["SQLALCHEMY_DATABASE_URI"] = database_url
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    db.init_app(app)
    CORS(app)

    from controllers.user_controller import user_blueprint
    from controllers.veiculo_controller import veiculo_blueprint
    from controllers.manutencao_controller import manutencao_blueprint
    from controllers.documento_controller import documento_blueprint

    app.register_blueprint(user_blueprint, url_prefix="/api")
    app.register_blueprint(veiculo_blueprint, url_prefix="/api")
    app.register_blueprint(manutencao_blueprint, url_prefix="/api")
    app.register_blueprint(documento_blueprint, url_prefix="/api")

    @app.route("/")
    def home():
        return {"message": "API do IntelligenceCar funcionando!"}

    return app

if __name__ == "__main__":
    app = create_app()
    app.run(debug=True)
