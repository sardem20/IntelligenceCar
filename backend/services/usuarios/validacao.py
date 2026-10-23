import re

_EMAIL_REGEX = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")
SENHA_MIN = 8


def validar_email(email):
    if not email or not email.strip():
        raise ValueError("Email é obrigatório.")
    email = email.strip().lower()
    if not _EMAIL_REGEX.match(email):
        raise ValueError("Email inválido.")
    return email


def normalizar_telefone(telefone):
    """Guarda só os dígitos: DDD + número (10 ou 11 dígitos). Aceita +55 e máscara."""
    if not telefone or not str(telefone).strip():
        raise ValueError("Telefone é obrigatório.")
    digitos = re.sub(r"\D", "", str(telefone))
    if len(digitos) in (12, 13) and digitos.startswith("55"):
        digitos = digitos[2:]
    if len(digitos) not in (10, 11):
        raise ValueError("Telefone inválido. Informe DDD + número, ex.: (31) 91234-5678.")
    if len(digitos) == 11 and digitos[2] != "9":
        raise ValueError("Celular inválido: o número deve começar com 9 após o DDD.")
    return digitos


def validar_senha(senha):
    if not senha or not isinstance(senha, str):
        raise ValueError("Senha é obrigatória.")
    if len(senha) < SENHA_MIN:
        raise ValueError(f"A senha deve ter no mínimo {SENHA_MIN} caracteres.")
    if not re.search(r"[A-Za-z]", senha) or not re.search(r"\d", senha):
        raise ValueError("A senha deve conter letras e números.")
    return senha
