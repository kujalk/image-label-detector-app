import { StorageManager } from '@aws-amplify/ui-react-storage';

export default function StorageManagerFile () {
  return (
    <StorageManager
      acceptedFileTypes={[
        // you can list file extensions:
        '.jpeg',
        '.jpg',
        // or MIME types:
        'image/png',
      ]}
      accessLevel="private"  
      maxFileCount={5}
      
      // Size is in bytes
      maxFileSize={10000000}
    />
  );
};