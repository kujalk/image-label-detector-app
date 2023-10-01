import * as React from "react";
import TopNavigation from "@cloudscape-design/components/top-navigation";

export default function Nav(props) {
    return (

      <TopNavigation
        identity={{
          href: "#",
          title: "Label Lytics",
          logo: {
            src:"logo.png",
            alt: "Service"
          }
        }}
  
        utilities={[
          {
            type: "button",
            text: "Blog",
            href: "https://example.com/",
            external: true,
            externalIconAriaLabel: " (opens in a new tab)"
          },
         
          {
            type: "menu-dropdown",
            text: props.user,
            description: props.userattr.email,
            iconName: "user-profile",
            onItemClick: props.signout,
            items: [
              {
                type: 'button',
                variant: 'primary-button',
                text: 'Signout',
                
              },
            ]
          }
        ]}
      />

    );
  }
  