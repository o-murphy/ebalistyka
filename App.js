import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, SafeAreaView, Button, Alert } from 'react-native';

export default function App() {

  const handleTextPress = () => console.log("Hello")
  const handleBtnPress = () => Alert.alert("Btn", "Message",
    { text: "OK", onPress: () => console.log("OK") },
    { text: "Cancel", onPress: () => console.log("Cancel") },
  )

  return (
    <SafeAreaView style={styles.container}>
      <Text onPress={handleTextPress}>Hello!</Text>
      <Button title="Press" onPress={handleBtnPress} />
      <StatusBar style="auto" />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
