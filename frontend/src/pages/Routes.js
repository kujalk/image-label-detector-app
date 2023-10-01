import SideNav from './sideNavigation.js';
import Grid from "@cloudscape-design/components/grid";
import Uploader from '../components/uploadImage';
import { BrowserRouter as Router,Routes, Route, Link } from 'react-router-dom';

import SearchImage from '../components/viewImage.js';
import SearchLabels from '../components/viewLabels.js';

export default function RoutePath() {
  return (
    <Router>
      <Grid
      gridDefinition={[
        
        { colspan: { default: 9, xxs: 3 } },
        { colspan: { default: 3, xxs: 9 } }
      ]}
      >

        <div><SideNav></SideNav></div>
          <div>
                <Routes>
                <Route exact path='/' element={< Uploader />}></Route>
                <Route exact path='/page1' element={< Uploader />}></Route>
                <Route exact path='/page2' element={< SearchImage />}></Route>
                <Route exact path='/page3' element={< SearchLabels />}></Route>
                </Routes>
         </div>

        </Grid>
      </Router>

      
        
    

      
    
  );
}
