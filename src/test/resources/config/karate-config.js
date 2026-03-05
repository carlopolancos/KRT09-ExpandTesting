function fn() {

  var myProp = karate.properties['myProperty'];
  karate.log('System property myProperty:', myProp);

  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);

  var config = {}
  if (env == 'dev') {
    config.baseUrl = 'https://jsonplaceholder.typicode.com';
    // customize
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    config.baseUrl = 'https://e2e.example.com';
    // customize
  }
  return config;
}