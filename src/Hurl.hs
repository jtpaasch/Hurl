-- Hurl
-- For doing HTTP stuff.

module Hurl
( request
, requestUrl
, requestMethod
, requestHeaders
, requestBody
, constructRequest
, doRequest
, responseCode
, responseReason
, responseHeaders
, responseBody

{-
  url      
, protocol
, user
, host
, port
, path
, query
, hash
, constructUrl
-}

) where


-- For using Maybe.
import Data.Maybe

-- For uppercasing.
import Data.Char

-- For either stuff.
import Data.Either

-- For splitting lists/strings.
import Data.List.Split

-- The Network stuff.
import Network.HTTP
-- import Network.HTTP.Base
-- import Network.HTTP.Headers
import Network.URI


-- | All the options that go into an HTTP Request.
data RequestOptions = RequestOptions
    { requestUrl :: String 
    , requestMethod :: String
    , requestHeaders :: [String]
    , requestBody :: String
    }
    deriving (Show)

-- | @request@ returns a 'RequestOptions' record with default values.
request :: RequestOptions
request = RequestOptions
    { requestUrl = ""
    , requestMethod = ""
    , requestHeaders = []
    , requestBody = ""
    }

-- | @constructRequest@ takes a 'RequestOptions' record
--   and returns a 'Request' record.
constructRequest :: RequestOptions -> Request String
constructRequest options = Request
    { rqURI = constructURI (requestUrl options)
    , rqMethod = constructMethod (requestMethod options)
    , rqHeaders = constructHeaders (requestHeaders options)
    , rqBody = requestBody options
    }

-- Construct a URI record from a string.
-- If it can't be parsed, return an empty URI record.
constructURI :: String -> URI
constructURI url
    | isJust parsedUrl = fromJust parsedUrl
    | isNothing parsedUrl = URI
        { uriScheme = ""
        , uriAuthority = Nothing
        , uriPath = ""
        , uriQuery = ""
        , uriFragment = ""
        }
    where parsedUrl = parseURI url

-- Construct a method record.
constructMethod :: String -> RequestMethod
constructMethod method
    | httpVerb == "GET"     = GET
    | httpVerb == "POST"    = POST
    | httpVerb == "PUT"     = PUT
    | httpVerb == "DELETE"  = DELETE
    | httpVerb == "HEAD"    = HEAD
    | httpVerb == "OPTIONS" = OPTIONS
    | httpVerb == "TRACE"   = TRACE
    | httpVerb == "CONNECT" = CONNECT
    | otherwise             = Custom httpVerb
    where httpVerb = map toUpper method

-- Construct a list of headers.
constructHeaders :: [String] -> [Header]
constructHeaders headers = map constructHeader headers

-- Construct a Header from a string.
constructHeader :: String -> Header
constructHeader header = 
    Header headerName value
    where pieces = splitOn ":" header
          name = pieces !! 0
          value = pieces !! 1
          headerName = HdrCustom name

-- | @doRequest@ performs a request.
doRequest :: (HStream ty) => Request ty -> IO (Response ty)
doRequest request = do
    let response = simpleHTTP request
    contents <- response
    unwrapResponse contents

-- unwrapResponse :: Result (Response ty) -> IO (Response ty)
unwrapResponse (Left err) = fail (show err)
unwrapResponse (Right response) = return response

-- | @responseCode@ extracts the HTTP response code from the response. 
--   The response code is returned as a tuple.
-- responseCode :: Response a -> (Int, Int, Int)
responseCode response = rspCode response

-- | @responseReason@ extracts the HTTP reason from the response.
responseReason :: Response a -> String
responseReason response = rspReason response

-- | @responseHeaders@ extracts the headers from the response.
responseHeaders :: Response a -> [Header]
responseHeaders response = rspHeaders response

-- | @responseBody@ extracts the body from the response.
responseBody :: Response String -> String
responseBody response = rspBody response


{- URL STUFF
-- --------------------------------------------------------

-- This is a data type that contains all the parts of a URL.
data UrlParts = UrlParts 
    { protocol :: String
    , user :: String
    , host :: String
    , port :: String
    , path :: String
    , query :: String
    , hash :: String
    } deriving (Show)

-- This is a function that returns a `UrlParts` record
-- with default values.
url :: UrlParts
url = UrlParts 
    { protocol="http"
    , user = ""
    , host = ""
    , port = ""
    , path = ""
    , query = ""
    , hash = ""
    }

-- This function takes a UrlParts record and 
-- constructs a URIAuth record from it.
constructUriAuth :: UrlParts -> URIAuth
constructUriAuth urlParts = URIAuth 
    { uriUserInfo=(constructUriUserInfo (user urlParts))
    , uriRegName=(host urlParts)
    , uriPort=(constructUriPort (port urlParts))
    }

-- This function takes a UrlParts record and builds
-- a Network.URI record from it.
constructUrl :: UrlParts -> URI
constructUrl urlParts = URI 
    { uriScheme=(constructProtocol (protocol urlParts))
    , uriAuthority=(Just (constructUriAuth urlParts))
    , uriPath=(path urlParts)
    , uriQuery=(query urlParts)
    , uriFragment=(constructHash (hash urlParts))
    }

-- This function makes sure a non-empty string 
-- has a colon after it, e.g., 'http' becomes 'http:'.
constructProtocol :: String -> String
constructProtocol x 
    | length x > 0 = x ++ ":"
    | otherwise = x

-- This function makes sure a non-empty string has
-- an ampersand at the end, e.g., 'joe' becomes 'joe@'.
constructUriUserInfo :: String -> String
constructUriUserInfo x 
    | length x > 0 = x ++ "@"
    | otherwise = x

-- This function makes sure a non-empty string 
-- has a colon before it, e.g., '42' becomes ':42'.
constructUriPort :: String -> String
constructUriPort x 
    | length x > 0 = ":" ++ x
    | otherwise = x

-- This function makes sure a non-empty string
-- has a hash before it, e.g., 'foo' becomes '#foo'.
constructHash :: String -> String
constructHash x 
    | length x > 0 = "#" ++ x
    | otherwise = x

-}
