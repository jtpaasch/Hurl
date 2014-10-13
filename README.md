Hurl
====

A simple way to make (very simple) HTTP requests, and then work with the response. This is basically a convenience wrapper around `Network.HTTP` functionality.

Define the request options:

    let requestOptions = { requestMethod = "GET"
                         , requestURL = "http://httpbin.org"
                         , requestHeaders = [ "Content-Type: text/html"
                                            , "Accept: text/html"
                                            ]
        }
    print requestOptions

Construct a request from those options:

    let theRequest = constructRequest requestOptions
    print theRequest

Perform the request:

    let theResponse = doRequest theRequest

Unwrap the contents:

    contents <- theResponse
    print contents

Pull out various pieces of the response:

    let code = responseCode contents
    let headers = responseHeaders contents
    let body = responseBody contents

    print code
    print headers 
    print body

