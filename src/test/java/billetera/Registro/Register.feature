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

  Scenario: Registrar usuario2
    Given path '/auth/v1/register'
    And header x-channel = 'POSTMAN'
    * def usuario2 = karate.get('global.usuarios')[1]
    * print 'usuario2:' , usuario2
    * request usuario2
    When method post
    Then status 201
    And print response