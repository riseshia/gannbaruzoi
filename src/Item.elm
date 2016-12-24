module Item exposing (..)

import Task exposing (Task)
import GraphQL exposing (apply)
import Http
import Json.Decode exposing (..)
import Json.Encode exposing (encode, object)


url : String
url =
    "http://localhost:8080/graphql"


type alias QueryItemResult =
    { item :
        { id : Maybe String
        }
    }


getItem : { id : String } -> Task Http.Error QueryItemResult
getItem params =
    let
        query =
            """query getItem($id: String!) { item(id: $id) { id } }"""
    in
        let
            params =
                object
                    [ ( "id", Json.Encode.string params.id )
                    ]
        in
            GraphQL.query url query "getItem" (encode 0 params) queryItemResult


queryItemResult : Decoder QueryItemResult
queryItemResult =
    map QueryItemResult
        ("item" := ("id" := string))
