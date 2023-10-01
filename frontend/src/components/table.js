import * as React from "react";
import Table from "@cloudscape-design/components/table";
import Box from "@cloudscape-design/components/box";
import Header from "@cloudscape-design/components/header";
import Pagination from "@cloudscape-design/components/pagination";

export function ListTable (props) {
  return (
    <Table
      columnDefinitions={[
        {
          id: "imagename",
          header: "Image name",
          cell: e => e.imagename,
          width: 170,
          minWidth: 165,
          sortingField: "name",
          isRowHeader: true
        },
        {
          id: "labels",
          header: "Labels",
          cell: e => e.labels,
          width: 110,
          minWidth: 110,
          sortingField: "type"
        },
      ]}
      items={props.items}
      loadingText="Loading resources"
      resizableColumns
      empty={
        <Box
          margin={{ vertical: "xs" }}
          textAlign="center"
          color="inherit"
        >
        </Box>
      }
    //   filter={
    //     <TextFilter
    //       filteringPlaceholder="Find resources"
    //       filteringText=""
    //     />
    //   }
      header={
        <Header>Output</Header>
      }
      pagination={
        <Pagination currentPageIndex={1} pagesCount={1} />
      }
    />
  );
}