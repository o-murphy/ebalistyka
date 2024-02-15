import React from 'react';
import { View } from "react-native";
import {Text, Button, TextInput} from 'react-native-paper';
import useUserData from './UseUserData.ts.bak'; // Adjust the path as necessary

const UserDataExample = () => {
  const [userData, saveUserData] = useUserData();

  // Example function to update user data
  const updateUserData = () => {
    const updatedData = { ...userData, name: 'Jane Doe' }; // Modify as needed
    saveUserData(updatedData);
  };

  const changeUserName = (text) => {
      console.log(text)
      const updatedData = { ...userData, name: text }; // Modify as needed
      saveUserData(updatedData);
  };
  console.log(userData)
  return (
    <View>
      {userData ? (
        <Text>Welcome, {userData.name}</Text>
      ) : (
        <Text>Loading...</Text>
      )}
        <Button mode="outlined" onPress={updateUserData}>Reset user data</Button>
      <TextInput value={userData ? userData.name : null} onChangeText={changeUserName}/>
    </View>
  );
};

export default UserDataExample;