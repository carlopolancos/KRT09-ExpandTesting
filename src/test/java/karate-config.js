function fn() {
	var env = karate.env; // get system property 'karate.env'
	karate.log('karate.env system property was:', env);
	
	if (!env) {
	env = 'dev';
	}
	
	var config = {
	env: env,
	myVarName: 'someValue',
	username: 'carlo.polancos@awsys-i.com',
	password: 'passSampleword',
	_url: 'https://practice.expandtesting.com/notes/api',
	}
	
	if (env == 'dev') {
		config.username = 'author'
		config.password = 'authorpassword'
	} else if (env == 'e2e') {
		config.username = 'user'
		config.password = 'userpassword'
	} else if (env == 'staging') {
		//Initialize config for staging
		config.username = 'carlo.polancos@awsys-i.com'
		config.password = 'passSampleword'
		config._url = 'https://practice.expandtesting.com/notes/api'
	} else if (env == 'preprod') {
		//Initialize config for preprod
		config.username = 'preprodadmin1'
		config.password = 'preprodwelcome'
		config._url = 'http://localhost:9897'
	} else if (env == 'prod') {
		//Initialize config for prod
		config.username = 'prodadmin1'
		config.password = 'prodwelcome'
		config._url = 'http://localhost:9897'
	}
  
	karate.configure('logPrettyRequest', true);
	karate.configure('logPrettyResponse', true);
	return config;
}