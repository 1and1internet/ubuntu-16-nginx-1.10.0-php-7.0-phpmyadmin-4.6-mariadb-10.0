def process(key, value):
    if key == 'sql_mode':
        if isinstance(value, list):
		    return ','.join(value)
    return value