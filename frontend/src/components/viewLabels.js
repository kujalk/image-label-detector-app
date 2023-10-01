import * as React from "react";
import Container from "@cloudscape-design/components/container";
import SpaceBetween from "@cloudscape-design/components/space-between";
import Box from "@cloudscape-design/components/box";
import Tiles from "@cloudscape-design/components/tiles";
import Button from "@cloudscape-design/components/button";
import Input from "@cloudscape-design/components/input";
import { Auth} from 'aws-amplify'
import { ListTable} from "./table";
import Grid from "@cloudscape-design/components/grid";
import awsExports from '../aws-exports';

Auth.configure(awsExports);

export default function SearchLabels () {

  const [value, setValue] = React.useState("labels");
  const [key, setKey] = React.useState("");
  const [tabledata, setTabledata] = React.useState([]);

  async function callApi() {
    const user = await Auth.currentAuthenticatedUser()
    const token = user.signInUserSession.idToken.jwtToken

    //console.log("token: ", token)

    const url = awsExports.aws_api_url //'https://kbsgb00m5h.execute-api.ap-southeast-1.amazonaws.com/dev/labels';

    const params = (value === 'labels') ? { labels: key } : { image: key };

    const queryParams = new URLSearchParams(params).toString();
    const apiUrl = `${url}?${queryParams}`;

    const requestData = {
    headers: {
        Authorization: token
    }
    };

    const response = await fetch(apiUrl, requestData);
    const data = await response.json();

    setTabledata(data)
}


  return (
    <Container>
      <SpaceBetween direction="vertical" size="s">
        <SpaceBetween direction="vertical" size="xxs">
          <Box variant="h2">Search Labels in your Object</Box>
        </SpaceBetween>

        <Grid gridDefinition={[ { colspan: { default: 6, xxs: 6 } }]}>
        
          <div>
            <Tiles
              onChange={({ detail }) => setValue(detail.value)}
              value={value}
              items={[
                { label: "By Images", value: "images" },
                { label: "By Labels", value: "labels" }
              ]}
            />
          </div>
        </Grid>

        <Grid gridDefinition={[ { colspan: { default: 4, xxs: 4 } }]}>
              <div>
              <Input
              onChange={({ detail }) => setKey(detail.value)}
              value={key}
              inputMode="text"
              type="search"
        />
              </div>
        </Grid>
        

            <Button onClick={callApi}>Search</Button>


            <ListTable items={tabledata}></ListTable>
      </SpaceBetween>

      

      
    </Container>

      
  );
}