import re

# Placa antiga (ABC1234) ou Mercosul (ABC1D23)
_PLACA_REGEX = re.compile(r"^[A-Z]{3}[0-9][A-Z0-9][0-9]{2}$")


def normalizar_placa(placa):
    if not placa or not str(placa).strip():
        raise ValueError("Placa é obrigatória.")
    placa = str(placa).strip().upper().replace("-", "").replace(" ", "")
    if not _PLACA_REGEX.match(placa):
        raise ValueError("Placa inválida. Use o formato ABC1234 ou ABC1D23.")
    return placa
