{
	// Application spesific settings
	"application": {
		// Root path for the application
		"root_path": "/cppcms",
		"blog" : {
			"path": "res/posts/",
			"base_url": "/blog/",
		}
	},

	"service": {
		//"api": "http",
		//"port": 8080,
		"api": "fastcgi",
		"socket": "/var/run/lighttpd/cppcms-fcgi.socket",
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
