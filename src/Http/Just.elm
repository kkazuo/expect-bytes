module Http.Just exposing (expectBytes)

{-| Expect Bytes with Http


# Expect

@docs expectBytes

-}

import Bytes exposing (Bytes)
import Http


{-| Expect the response body to be binary data.

    import Bytes exposing (Bytes)
    import Http
    import Http.Just

    type Msg
        = GotBytes (Result Http.Error Bytes)

    getBytes : Cmd Msg
    getBytes =
        Http.get
            { url = "/bytes"
            , expect = Http.Just.expectBytes GotBytes
            }

-}
expectBytes : (Result Http.Error Bytes -> msg) -> Http.Expect msg
expectBytes toMsg =
    Http.expectBytesResponse toMsg <|
        \response ->
            case response of
                Http.BadUrl_ url ->
                    Err (Http.BadUrl url)

                Http.Timeout_ ->
                    Err Http.Timeout

                Http.NetworkError_ ->
                    Err Http.NetworkError

                Http.BadStatus_ metadata _ ->
                    Err (Http.BadStatus metadata.statusCode)

                Http.GoodStatus_ _ body ->
                    Ok body
