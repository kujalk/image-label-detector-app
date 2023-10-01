import * as React from "react";
import SideNavigation from "@cloudscape-design/components/side-navigation";
import { useNavigate } from 'react-router-dom';

export default function SideNav() {
  const navigate = useNavigate(); // Get the history object
  
  return (
    <SideNavigation
 
      header={{ href: "#/", text: "Image Labels Detector" }}
      onFollow={event => {
        if (!event.detail.external) {
          event.preventDefault();
          navigate(event.detail.href); // Use history.push to navigate
        }
      }}

      items={[
        { type: "link", text: "Upload Image", href: "/page1" },
        { type: "link", text: "View Image", href: "/page2" },
        { type: "link", text: "Label Predictions", href: "/page3" },
        { type: "divider" },
        {
          type: "link",
          text: "Documentation",
          href: "https://example.com",
          external: true
        }
      ]}
    />
  );
}