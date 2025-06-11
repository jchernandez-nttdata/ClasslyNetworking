# Classly Networking
ClasslyNetworking es un cliente de red asincrónico en Swift que sigue un enfoque simple, claro y seguro para realizar peticiones HTTP.
Utiliza protocolos para definir solicitudes genéricas, maneja errores de forma explícita y permite integrar diferentes tipos de requests, incluyendo aquellos con body.

Este módulo te permite desacoplar la lógica de red del resto de tu app de manera limpia y reutilizable. Al utilizarlo, puedes enviar peticiones HTTP (GET, POST, PUT, DELETE) y obtener respuestas tipadas (Decodable) de forma asincrónica con async/await.

## Componentes principales
1. NetworkManager
El motor central del módulo. Se encarga de construir la petición, enviarla y decodificar la respuesta.
```swift
let manager = NetworkManager()
let response = try await manager.performRequest(MyRequest())
```

2. Request (protocolo)
Todo request debe adoptar este protocolo. Define:

| Propiedad          | Tipo                | Descripción                                     |
| ------------------ | ------------------- | ----------------------------------------------- |
| `baseURL`          | `String`            | URL base del servicio                           |
| `endpoint`         | `String`            | Ruta específica (ej. `/auth/login`)             |
| `urlMethod`        | `HTTPMethod`        | GET, POST, etc.                                 |
| `validStatusCodes` | `[Int]`             | Códigos HTTP aceptados como "válidos"           |
| `headers`          | `[String: String?]` | Cabeceras HTTP personalizadas                   |
| `params`           | `[String: String]?` | Parámetros de query (solo para GET normalmente) |
| `Response`         | `Decodable`         | Tipo que esperas recibir como respuesta         |

3. RequestWithBody
Extiende a Request para permitir peticiones con un cuerpo (body) tipo Encodable.

4. HTTPMethod
Enum con los métodos HTTP disponibles: `.GET, .POST, .PUT, .DELETE.`

5. NetworkError
Enum que agrupa los posibles errores de red de forma clara:

- invalidURL
- requestFailed(Error)
- invalidResponseType
- invalidResponse(statusCode: Int)
- decodingFailed(Error)
- encodingFailed(Error)

## Ejemplo de uso
1. Define tu Request
```swift
struct GetUsersRequest: Request {
    typealias Response = [UserDTO]

    var urlMethod: HTTPMethod = .GET
    var baseURL: String = "https://api.classly.com"
    var endpoint: String = "/users"
    var validStatusCodes: [Int] = [200]
    var headers: [String : String?] = ["Authorization": "Bearer token"]
    var params: [String : String]? = ["limit": "10"]
}
```
2. Llama al manager

```swift
let manager = NetworkManager()
let users = try await manager.performRequest(GetUsersRequest())
```

## Integración en tu proyecto
Este paquete está pensado para usarse como Swift Package remoto.
```swift
    dependencies: [
        .package(
            url: "https://github.com/jchernandez-nttdata/ClasslyNetworking.git",
            .upToNextMinor(from: .init(stringLiteral: "1.0.0"))
        )
    ],
```
