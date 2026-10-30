Feature: Registrar usuarios

  Background:
    * url 'http://134.209.211.10:4001'

    * def randomInt = function(max) { return Math.floor(Math.random() * max) }
    * def randomBetween = function(min, max) { return min + Math.floor(Math.random() * (max - min + 1)) }

    * def nombres = ['Ana', 'Luis', 'Mateo', 'Sofia', 'Pedro', 'Carla', 'Valeria', 'Daniel']
    * def apellidos = ['Gomez', 'Perez', 'Silva', 'Rojas', 'Torres', 'Luna', 'Mendoza', 'Castro']
    * def palabrasEmail = ['prueba', 'demo', 'dev', 'qa', 'usuario', 'test']

    * def generarNombre = function() {return nombres[randomInt(nombres.length)] + ' ' + apellidos[randomInt(apellidos.length)]}

    * def generarEmail = function() {return palabrasEmail[randomInt(palabrasEmail.length)] + '@test.com'}

    * def generarPin = function() {return String(randomBetween(100000, 999999))}

    * def generarUsuario = function() {return {phone: String(randomBetween(900000001, 999999999)),fullName: generarNombre(),email: generarEmail(),pin: generarPin()}}

    * def usuarios = []
    * eval usuarios.push(generarUsuario())
    * eval usuarios.push(generarUsuario())

    * karate.set('global.usuarios', usuarios)

    * def usuariosGlobal = karate.get('global.usuarios')
    * print 'Usuarios globales:', usuariosGlobal

  Scenario: Registrar usuario1
    Given path '/auth/v1/register'
    And header x-channel = 'POSTMAN'
    * def usuario1 = karate.get('global.usuarios')[0]
    * request usuario1
    When method post
    Then status 201
    And print response
    And karate.write(usuario1, 'datausers/user1.json')

  Scenario: Registrar usuario2
    Given path '/auth/v1/register'
    And header x-channel = 'POSTMAN'
    * def usuario2 = karate.get('global.usuarios')[1]
    * request usuario2
    When method post
    Then status 201
    And print response
    And karate.write(usuario2, 'datausers/user2.json')

  Scenario: Login de user 1
    Given path '/auth/v1/login'
    And header x-channel = 'POSTMAN'
    * def credentials_user1 = read('file:target/datausers/user1.json')
    * string user1_phone = credentials_user1.phone
    * string user1_pin = credentials_user1.pin
    * request userpass1 = { phone: user1_phone, pin: user1_pin }
    When method post
    Then status 200
    And karate.write(response, 'datausers/sesion_user1.json')

  Scenario: Depositar a user 1
    Given url 'http://134.209.211.10:4002/wallet/v1/deposit'
    And header x-channel = 'POSTMAN'
    * def user1data = read('file:target/datausers/sesion_user1.json')
    And header Authorization = 'Bearer ' + user1data.token
    And request
    """
    {
      "amount": 500
    }
    """
    When method post
    Then status 200
    And match response.newBalance == 500
    And karate.write(response, 'datausers/1ersaldo_user1.json')
