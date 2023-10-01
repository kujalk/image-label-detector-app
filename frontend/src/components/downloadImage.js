import { StorageImage } from '@aws-amplify/ui-react-storage';

export default function DefaultStorageImage (props) {

  return (
    <StorageImage
      imgKey={props.image}
      accessLevel="private"
      onStorageGetError={(error) => console.error(error)}
    />
  );
}