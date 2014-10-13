Hurl
====

A simple way to make (very simple) HTTP requests, and then work with the response. This is basically a convenience wrapper around `Network.HTTP` functionality.

Define the request options:

    -- Define various parts of the request.
    let requestOptions = { requestMethod = "GET"
                         , requestURL = "http://httpbin.org"
                         , requestHeaders = [ "Content-Type: text/html"
                                            , "Accept: text/html"
                                            ]
        }

    -- See what it looks like.
    print requestOptions

Construct a request from those options:

    -- Use the `constructRequest` function to build 
    -- a request from the `requestOptions`.
    let theRequest = constructRequest requestOptions

    -- See what it looks like.
    print theRequest

Perform the request:

    -- Use the `doRequest` method to perform the request.
    let theResponse = doRequest theRequest

    -- This can't be printed out.
    -- print theResponse -- This would throw an error.

Unwrap the contents:

    -- Use the `<-` operator to pull the contents out.
    contents <- theResponse

    -- See what it looks like.
    print contents

Pull out various pieces of the response:

    -- Use the `responseCode` function to get the response's status code.
    let code = responseCode contents

    -- Use the `responseHeaders` function to get the response's headers.
    let headers = responseHeaders contents

    -- Use the `responseBody` function to get the response's body.
    let body = responseBody contents

    -- See what they look like.
    print code
    print headers 
    print body

