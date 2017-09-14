def process(value):
	if isinstance(value, list):
		return ','.join(value)
	return value
