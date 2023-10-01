import * as React from "react";
import Container from "@cloudscape-design/components/container";
import SpaceBetween from "@cloudscape-design/components/space-between";
import Box from "@cloudscape-design/components/box";
import DefaultStorageImage from './downloadImage.js';
import Button from "@cloudscape-design/components/button";
import Input from "@cloudscape-design/components/input";
import Grid from "@cloudscape-design/components/grid";


export default function SearchImage () {

  const [value, setValue] = React.useState("");
  const [showImage, setShowImage] = React.useState(false);
  const [imageName, setImageName] = React.useState()

  const handleSearch = () => {
    console.log("Image is "+value)
    setImageName(value)
    setShowImage(true);
  }


  return (
    <Container>
      <SpaceBetween direction="vertical" size="s">

        <SpaceBetween direction="vertical" size="xxs">
          <Box variant="h2">Search your Images</Box>      
        </SpaceBetween>

        <Grid gridDefinition={[ { colspan: { default: 3, xxs: 3 } }]}>
          <div>
          <Input
              onChange={({ detail }) => setValue(detail.value)}
              value={value}
              inputMode="text"
              type="search"
        />
          </div>    
        </Grid>
        

        <Button onClick={handleSearch}>Search</Button>
        <div>
        {showImage && <DefaultStorageImage image={imageName}/>}
        </div>
      </SpaceBetween>
    </Container>

      
  );
}