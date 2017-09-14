import sql_mode as sql_mode

def process(key, value):
    if key == 'sql_mode':
        return sql_mode.process(value)
    return value