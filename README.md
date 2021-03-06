# Block

This is a prototype framework to create blocks of reusable logic similar to SwiftUI Views or React Components.

## Examples:

## Without Blocks

The example flow will be a shopping app gated with a user sign in flow.

#### First TIme User Flow

##### UI

Open App -> Splash -> Create Account -> Profile Page

##### Logic

This will only focus on the "Create Account" screen and the logic required to create a new user account.

`CreateAccountView`

    -> CreateAccountService.createNewUser(email:password:firstName:lastName:birthday)

`CreateAccountService.createNewUser`
    
    -> post:/api/create
        -> onSuccess
            -> post:/api/access_token
                -> onSuccess
                    -> Persist token to local storage
                    -> get:authenticated:/api/profile
                        -> onSuccess
                            -> Complete with profile
                        -> onFailure
                            -> Fail with error
                -> onFailure
                    -> Fail with error
        -> onFailure
            -> Fail with error

The above is psudocode for the `createNewUser` method. If we were to then move on to the returning user flow, we would have to write a `LoginService` that duplicated this logic except for the `post:/api/create` step. Any attempt to reuse this logic would require creating a separate Utility class that handles the login part, except that would then take all the responsibility away from the `LoginService`. The `CreateAccountService` could use a `LoginService`, except that is odd architecturally since they are at the same layer and one should not be dependent on the other.





## With Blocks

`CreateAccountView`

    -> Invoke CreateAccountSequence with state:(email:password:firstName:lastName:birthday)

`CreateNewUserBlock`

    -> post:/api/create
        -> onSuccess
            -> Complete
        -> onFailure
            -> Fail with error
    
`AccessTokenSequence`

    -> GetAccessTokenBlock -> PersistAccessTokenBlock

    `GetAccessTokenBlock`
        -> post:/api/access_token
            -> onSuccess
                -> Complete with token
            -> onFailure
                -> Fail with error
    
    `PersistAccessTokenBlock`
        -> Persist token to local storage
        -> Complete with token
    
`GetUserProfileBlock`

    -> get:authenticated:/api/profile
        -> onSuccess
            -> Complete with profile
        -> onFailure
            -> Fail with error

`CreateAccountSequence`

    -> CreateNewUserBlock -> AccessTokenSequence -> GetUserProfileBlock

Now that this flow is using Blocks, here is the login flow:

`LoginView`

    -> Invoke LoginSequence with state:(email:password:)

`LoginSequence`

    -> AccessTokenSequence -> GetUserProfileBlock

The logic of the application required no modifications to add an entire new flow for logging a user into the app. The flow for the `CreateAccountSequence` can be updated to be even simpler.

`CreateAccountSequence`

    -> CreateNewUserBlock -> LoginSequence

This way, any updates to `LoginSequence` would then be automatically picked up by the `CreateAccountSequence`

# License

MIT License

Copyright (c) 2021 Ericdowney

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
