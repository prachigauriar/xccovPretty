# xccovPretty

`xccovPretty` is a command-line tool for making Xcode’s `xccov` code coverage output prettier. While
`xccov` can produce human-readable output, line lengths can be pretty long, and directory
hierarchies aren’t clearly displayed. `xccovPretty` uses `xccov`’s JSON output to produce a more
readable version.

You may also be interested in `xccovPretty` if you’re interested in processing `xccov`’s JSON
output. The Models directory contains reusable model objects that can be used to decode them using
`Codable`.


## Installation

To install `xccovPretty`, just pull down the source and run

    xcodebuild install DSTROOT=/

This installs the tool in `/usr/local/bin`. You can further change the installation directory using
a combination of the `DSTROOT` and `INSTALL_PATH`. For example, `DSTROOT=$HOME` and
`INSTALL_PATH=opt/local/bin` would install the binary in `~/opt/local/bin`. Knock yourself out.


## Usage

To use `xccovPretty`, just pipe the output of `xccov view --json` to `xccovPretty`.

To learn more about `xccov`, read the [manpage](x-man-page://xccov) or check out
[XCBlog’s helpful article](https://medium.com/xcblog/xccov-xcode-code-coverage-report-for-humans-466a4865aa18).


## Example

    % xcrun xccov view --json /path/to/action.xccovreport | xccovPretty
    GrubAPI.framework                                               99.37% (1585/1595)
        /Users/pgauriar/Developer/GrubAPI/GrubAPI/
            Authentication/
                Configuration/
                    AuthenticatorConfiguration.swift                91.67% (11/12)
                    DeviceIdentityKeychainConfiguration.swift       100.00% (5/5)
                    SessionKeychainConfiguration.swift              100.00% (24/24)
                Authenticator.swift                                 99.53% (840/844)
                AuthenticatorError.swift                            100.00% (11/11)
                DeviceIdentityDataSource.swift                      100.00% (26/26)
                SessionStorage.swift                                100.00% (30/30)
                Internal API Client/
                    AccountCreationRequest.swift                    100.00% (13/13)
                    AnonymousSessionCreationRequest.swift           100.00% (6/6)
                    AnonymousSessionRefreshRequest.swift            100.00% (6/6)
                    APIClient.swift                                 95.00% (19/20)
                    APIClientProtocol.swift                         100.00% (84/84)
                    AuthenticatedSessionFetchRequest.swift          100.00% (6/6)
                    AuthenticatedSessionRefreshRequest.swift        100.00% (6/6)
                    CredentialUpdateRequest.swift                   100.00% (34/34)
                    DeviceIdentityAuthenticationRequest.swift       100.00% (6/6)
                    LogoutRequest.swift                             100.00% (8/8)
                    PasswordAuthenticationRequest.swift             100.00% (12/12)
                    ThirdPartyAccountAuthenticationRequest.swift    100.00% (40/40)
            Categories and Extensions/
                HTTPHeaderItem+BearerTokens.swift                   100.00% (3/3)
                Logger+PermissiveDecodableArray.swift               100.00% (19/19)
                Result+ErrorPredicates.swift                        100.00% (14/14)
            GrubAPI.swift                                           50.00% (3/6)
            Models/
                AnonymousSession.swift                              100.00% (16/16)
                AuthenticatedSession.swift                          100.00% (22/22)
                AuthenticationScope.swift                           100.00% (3/3)
                Claim.swift                                         100.00% (6/6)
                ClientID.swift                                      100.00% (3/3)
                Credential.swift                                    100.00% (27/27)
                OpenIDConnectTokenResponse.swift                    100.00% (3/3)
                RequestValidationError.swift                        96.15% (25/26)
                SecurityBrand.swift                                 100.00% (3/3)
                Session.swift                                       100.00% (8/8)
                SessionHandle.swift                                 100.00% (45/45)
                SignedDeviceIdentityToken.swift                     100.00% (3/3)
                ThirdPartyAccountConnection.swift                   100.00% (7/7)
                ValidationMessage.swift                             100.00% (75/75)
            Security API Client/
                CredentialFetchRequest.swift                        100.00% (34/34)
                SecurityAPIClient.swift                             100.00% (30/30)
                ThirdPartyAccountConnectionRequest.swift            100.00% (26/26)
                UserProfileUpdateRequest.swift                      100.00% (11/11)
            Utilities/
                StandardJSONResponseHandler.swift                   100.00% (9/9)
                VoidHTTPResponseTransformer.swift                   100.00% (3/3)


## License

All code is licensed under the MIT license. Do with it as you will.
