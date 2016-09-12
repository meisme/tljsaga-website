{
	// Application spesific settings
	"application": {
		// Root path for the application
		"root_path": "/"
	},

	"service": {
		"api": "http",
		"port": 8000,
	},

	"http": {
		"script_names": [
			"/cppcms",
		],
	},

	"security": {
		"display_error_message": true,
		"csrf": {
			"enable": true,
		},
	},

	"gzip": {
		"enable": false,
		"level": 1,
	},

	"logging": {
		"stderr": true,
		"level": "debug",
	}
}
