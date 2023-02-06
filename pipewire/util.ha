use types;

export fn strtoc(s: str) *char = {
	return (*(&s: *types::string)).data: *char;
};

