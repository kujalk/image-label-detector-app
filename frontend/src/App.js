//import logo from './logo.svg';
import './App.css';
import { Amplify } from 'aws-amplify';
import { Authenticator } from '@aws-amplify/ui-react';
import '@aws-amplify/ui-react/styles.css';
import awsExports from './aws-exports';

import Nav from './pages/topNavigation.js';

import RoutePath
 from './pages/Routes';
Amplify.configure(awsExports);

export default function App() {
  return (

    <Authenticator>

      {({ signOut, user }) => (
        <main>

        <Nav user={user.username} userattr={user.attributes} signout={signOut}></Nav>

        <RoutePath></RoutePath>

        </main>
      )}
      
    </Authenticator>
    
  );
}
