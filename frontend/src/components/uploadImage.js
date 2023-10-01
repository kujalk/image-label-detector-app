import * as React from "react";
import Container from "@cloudscape-design/components/container";
import SpaceBetween from "@cloudscape-design/components/space-between";
import Box from "@cloudscape-design/components/box";
import StorageManagerFile from './storage.js';


export default function Uploader () {

  return (
    <Container>
      <SpaceBetween direction="vertical" size="s">
        <SpaceBetween direction="vertical" size="xxs">
          <Box variant="h2">Upload your Images</Box>
        </SpaceBetween>
        <div><StorageManagerFile></StorageManagerFile></div> 
      </SpaceBetween>
    </Container>

  );
}